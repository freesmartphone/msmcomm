#include <msmrpc/rpc.h>
#include <arpa/inet.h>
#include <errno.h>
#include <debug.h>

extern int r_open(const char *router);
extern void r_close(int handle);
extern int r_read(int handle, char *buf, uint32 size);
extern int r_write(int handle, const char *buf, uint32 size);
extern int r_control(int handle, const uint32 cmd, void *arg);

static void xdr_std_destroy(xdr_s_type *xdr)
{
    /* whatever */
}

static bool_t xdr_std_control(xdr_s_type *xdr, int request, void *info)
{
    return r_control(xdr->fd, request, info);
}

static bool_t xdr_std_msg_done(xdr_s_type *xdr)
{
    /* whatever */
    return TRUE;
}

/* Outgoing message control functions */
static bool_t xdr_std_msg_start(xdr_s_type *xdr, 
                                 rpc_msg_e_type rpc_msg_type)
{

    /* xid is does not matter under our set of assumptions: that for a single
     * program/version channel, communication is synchronous.  If several
     * processes attempt to call functions on a program, then the rpcrouter
     * driver will ensure that the calls are properly muxed, because the
     * processes will have separate PIDs, and the rpcrouter driver uses PIDs to
     * keep track of RPC transactions.  For multiple threads in the same
     * process accessing the same program, we serialize access in clnt_call()
     * by locking a mutex around the RPC call.  If threads in the same process
     * call into different programs, then there is no issue, again because of
     * the use of a mutex in clnt_call().
     * 
     * NOTE: This comment assumes that the only way we talk to the RPC router
     *       from a client is by using clnt_call(), which is the case for all
     *       client code generated by rpcgen().
     *
     * NOTE: The RPC router driver will soon be able to open a separate device
     *       file for each program/version channel.  This will allow for
     *       natural multiplexing among clients, as we won't have to rely on
     *       the mutex for the case where different programs are being called
     *       into by separate threads in the same process.  When this happens,
     *       we'll need to optimize the RPC library to add a separate mutex for
     *       each program/version channel, which will require some sort of
     *       registry.
     */

    if (rpc_msg_type == RPC_MSG_CALL) xdr->xid++;

    /* We start writing into the outgoing-message buffer at index 32, because
       we need to write header information before we send the message.  The
       header information includes the destination address and the pacmark
       header.
    */
    xdr->out_next = (RPC_OFFSET+2)*sizeof(uint32);

    /* we write the pacmark header when we send the message. */
    ((uint32 *)xdr->out_msg)[RPC_OFFSET] = htonl(xdr->xid);
    /* rpc call or reply? */
    ((uint32 *)xdr->out_msg)[RPC_OFFSET+1] = htonl(rpc_msg_type);

    return TRUE;
}

static bool_t xdr_std_msg_abort(xdr_s_type *xdr)
{
    /* dummy */
    return TRUE;
}

/* Can be used to send both calls and replies. */

extern bool_t xdr_recv_reply_header(xdr_s_type *xdr, rpc_reply_header *reply);

#include <stdio.h>

static bool_t xdr_std_msg_send(xdr_s_type *xdr)
{  
    /* Send the RPC packet. */
    if (r_write(xdr->fd, (void *)xdr->out_msg, xdr->out_next) !=
            xdr->out_next)
        return FALSE;
        
    return TRUE;
}

static bool_t xdr_std_read(xdr_s_type *xdr)
{
    xdr->in_len = r_read(xdr->fd, (void *)xdr->in_msg, RPCROUTER_MSGSIZE_MAX);
    if (xdr->in_len < 0) return FALSE;

    if (xdr->in_len < (RPC_OFFSET+2)*4) {
        xdr->in_len = -1;
        return FALSE;
    }

    xdr->in_next = (RPC_OFFSET+2)*4;
    return TRUE;
}

/* Message data functions */
static bool_t xdr_std_send_uint32(xdr_s_type *xdr, const uint32 *value)
{
    if (xdr->out_next >= RPCROUTER_MSGSIZE_MAX - 3) return FALSE;
    *(int32 *)(xdr->out_msg + xdr->out_next) = htonl(*value);
    xdr->out_next += 4;
    return TRUE;
}

static bool_t xdr_std_send_int8(xdr_s_type *xdr, const int8 *value)
{
    uint32 val = *value;
    return xdr_std_send_uint32(xdr, &val);
}

static bool_t xdr_std_send_uint8(xdr_s_type *xdr, const uint8 *value)
{
    uint32 val = *value;
    return xdr_std_send_uint32(xdr, &val);
}

static bool_t xdr_std_send_int16(xdr_s_type *xdr, const int16 *value)
{
    uint32 val = *value;
    return xdr_std_send_uint32(xdr, &val);
}

static bool_t xdr_std_send_uint16(xdr_s_type *xdr, const uint16 *value)
{
    uint32 val = *value;
    return xdr_std_send_uint32(xdr, &val);
}

static bool_t xdr_std_send_int32(xdr_s_type *xdr, const int32 *value)
{
    return xdr_std_send_uint32(xdr, (uint32_t *)value);
}

static bool_t xdr_std_send_bytes(xdr_s_type *xdr, const uint8 *buf, 
                                   uint32 len)
{
    if (xdr->out_next + len > RPCROUTER_MSGSIZE_MAX) return FALSE; 
    while(len--)
        xdr->out_msg[xdr->out_next++] = *buf++;
    while(xdr->out_next % 4)
        xdr->out_msg[xdr->out_next++] = 0;
    return TRUE;
}

#if 0
#include <unwind.h> 
typedef struct
{
    size_t count;
    intptr_t* addrs;
} stack_crawl_state_t;

static _Unwind_Reason_Code trace_function(_Unwind_Context *context, void *arg)
{
    stack_crawl_state_t* state = (stack_crawl_state_t*)arg;
    if (state->count) {
        intptr_t ip = (intptr_t)_Unwind_GetIP(context);
        if (ip) {
            state->addrs[0] = ip;
            state->addrs++;
            state->count--;
        }
    }
    return _URC_NO_REASON;
}

static inline
int get_backtrace(intptr_t* addrs, size_t max_entries)
{
    stack_crawl_state_t state;
    state.count = max_entries;
    state.addrs = (intptr_t*)addrs;
    _Unwind_Backtrace(trace_function, (void*)&state);
    return max_entries - state.count;
}
#endif

static bool_t xdr_std_recv_uint32(xdr_s_type *xdr, uint32 *value)
{
#if 0
    intptr_t *trace[20], *tr;
    int nc = get_backtrace(trace, 20);
    tr = trace;
    while(nc--)
        D("\t%02d: %p\n", nc, *tr++);
#endif
        
    if (xdr->in_next + 4 > xdr->in_len) { return FALSE; }
    if (value) *value = ntohl(*(uint32 *)(xdr->in_msg + xdr->in_next));
    xdr->in_next += 4;
    return TRUE;
}

#define RECEIVE                                 \
    uint32 val;                                 \
    if (xdr_std_recv_uint32(xdr, &val)) {       \
        *value = val;                           \
        return TRUE;                            \
    }                                           \
    return FALSE

static bool_t xdr_std_recv_int8(xdr_s_type *xdr, int8 *value)
{
    RECEIVE;
}

static bool_t xdr_std_recv_uint8(xdr_s_type *xdr, uint8 *value)
{
    RECEIVE;
}

static bool_t xdr_std_recv_int16(xdr_s_type *xdr, int16 *value)
{
    RECEIVE;
}

static bool_t xdr_std_recv_uint16(xdr_s_type *xdr, uint16 *value)
{
    RECEIVE;
}

#undef RECEIVE

static bool_t xdr_std_recv_int32(xdr_s_type *xdr, int32 *value)
{
    return xdr_std_recv_uint32(xdr, (uint32 * )value);
}

static bool_t xdr_std_recv_bytes(xdr_s_type *xdr, uint8 *buf, uint32 len)
{
    if (xdr->in_next + (int)len > xdr->in_len) return FALSE;     
    if (buf) memcpy(buf, &xdr->in_msg[xdr->in_next], len);
    xdr->in_next += len;
    xdr->in_next = (xdr->in_next + 3) & ~3;
    return TRUE;
}

const xdr_ops_s_type xdr_std_xops = {

    xdr_std_destroy,
    xdr_std_control,
    xdr_std_read,
    xdr_std_msg_done,
    xdr_std_msg_start,
    xdr_std_msg_abort,
    xdr_std_msg_send,

    xdr_std_send_int8,
    xdr_std_send_uint8,
    xdr_std_send_int16,
    xdr_std_send_uint16,
    xdr_std_send_int32,
    xdr_std_send_uint32,
    xdr_std_send_bytes,
    xdr_std_recv_int8,
    xdr_std_recv_uint8,
    xdr_std_recv_int16,
    xdr_std_recv_uint16,
    xdr_std_recv_int32,
    xdr_std_recv_uint32,
    xdr_std_recv_bytes,
};

xdr_s_type *xdr_init_common(const char *router, int is_client)
{
    xdr_s_type *xdr = (xdr_s_type *)calloc(1, sizeof(xdr_s_type)); 

    xdr->xops = &xdr_std_xops;

    xdr->fd = r_open(router);
    if (xdr->fd < 0) {
        E("ERROR OPENING [%s]: %s\n", router, strerror(errno));
        free(xdr);
        return NULL;
    }
    xdr->is_client = is_client;

    D("OPENED [%s] fd %d\n", router, xdr->fd);
    return xdr;
}

xdr_s_type *xdr_clone(xdr_s_type *other)
{
    xdr_s_type *xdr = (xdr_s_type *)calloc(1, sizeof(xdr_s_type)); 

    xdr->xops = &xdr_std_xops;

    xdr->fd = dup(other->fd);
    if (xdr->fd < 0) {
        E("ERROR DUPLICATING FD %d: %s\n", other->fd, strerror(errno));
        free(xdr);
        return NULL;
    }

    xdr->xid = xdr->xid;
    xdr->x_prog = other->x_prog;
    xdr->x_vers = other->x_vers;
    xdr->is_client = other->is_client;

    D("CLONED fd %d --> %d\n", other->fd, xdr->fd);
    return xdr;
}

void xdr_destroy_common(xdr_s_type *xdr)
{
    D("CLOSING fd %d\n", xdr->fd);
    r_close(xdr->fd);
    free(xdr);
}
