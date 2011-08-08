/**
 * This file is part of libmsmcomm.
 *
 * (C) 2011 Simon Busch <morphis@gravedo.de>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301  USA
 *
 **/

namespace Msmrpc
{
    /**
     * This are all known program types extracted from arch/arm/mach-msm/smd_rpc_sym
     **/
    public enum ProgramType
    {
        CM = 0x30000000,
        DB = 0x30000001,
        SND = 0x30000002,
        WMS = 0x30000003,
        PDSM = 0x30000004,
        MISC_MODEM_APIS = 0x30000005,
        MISC_APPS_APIS = 0x30000006,
        JOYST = 0x30000007,
        VJOY = 0x30000008,
        JOYSTC = 0x30000009,
        ADSPRTOSATOM = 0x3000000A,
        ADSPRTOSMTOA = 0x3000000B,
        I2C = 0x3000000C,
        TIME_REMOTE = 0x3000000D,
        NV = 0x3000000E,
        CLKRGM_SEC = 0x3000000F,
        RDEVMAP = 0x30000010,
        FS_RAPI = 0x30000011,
        PBMLIB = 0x30000012,
        AUDMGR = 0x30000013,
        MVS = 0x30000014,
        DOG_KEEPALIVE = 0x30000015,
        GSDI_ExP = 0x30000016,
        AUTH = 0x30000017,
        NVRUIMI = 0x30000018,
        MMGSDILIB = 0x30000019,
        CHARGER = 0x3000001A,
        UIM = 0x3000001B,
        PDSM_ATL = 0x3000001D,
        FS_XMOUNT = 0x3000001E,
        SECUTIL = 0x3000001F,
        MCCMEID = 0x30000020,
        PM_STROBE_FLASH = 0x30000021,
        DSHDR_JCDMA_APIS = 0x30000022,
        SMD_BRIDGE = 0x30000023,
        SMD_PORT_MGR = 0x30000024,
        BUS_PERF = 0x30000025,
        BUS_MON_REMOTE = 0x30000026,
        MC = 0x30000027,
        MCCAP = 0x30000028,
        MCCDMA = 0x30000029,
        MCCDS = 0x3000002A,
        MCCSCH = 0x3000002B,
        MCCSRID = 0x3000002C,
        SNM = 0x3000002D,
        MCCSYOBJ = 0x3000002E,
        DS707_APIS = 0x3000002F,
        DSRLP_APIS = 0x30000031,
        RLP_APIS = 0x30000032,
        DS_MP_SHIM_MODEM = 0x30000033,
        DSHDR_APIS = 0x30000034,
        DSHDR_MDM_APIS = 0x30000035,
        DS_MP_SHIM_APPS = 0x30000036,
        HDRMC_APIS = 0x30000037,
        PMAPP_OTG = 0x3000003A,
        DIAG = 0x3000003B,
        GSTK_ExP = 0x3000003C,
        DSBC_MDM_APIS = 0x3000003D,
        HDRMRLP_MDM_APIS = 0x3000003E,
        HDRMRLP_APPS_APIS = 0x3000003F,
        HDRMC_MRLP_APIS = 0x30000040,
        PDCOMM_APP_API = 0x30000041,
        DSAT_APIS = 0x30000042,
        RFM = 0x30000043,
        CMIPAPP = 0x30000044,
        DSMP_UMTS_MODEM_APIS = 0x30000045,
        DSMP_UMTS_APPS_APIS = 0x30000046,
        DSUCSDMPSHIM = 0x30000047,
        TIME_REMOTE_ATOM = 0x30000048,
        CLKRGM_EVENT = 0x30000049,
        SD = 0x3000004A,
        MMOC = 0x3000004B,
        WLAN_ADP_FTM = 0x3000004C,
        WLAN_CP_CM = 0x3000004D,
        FTM_WLAN = 0x3000004E,
        SDCC_CPRM = 0x3000004F,
        CPRMINTERFACE = 0x30000050,
        DATA_ON_MODEM_MTOA_APIS = 0x30000051,
        MISC_MODEM_APIS_NONWINMOB = 0x30000053,
        MISC_APPS_APIS_NONWINMOB = 0x30000054,
        PMEM_REMOTE = 0x30000055,
        TCxOMGR = 0x30000056,
        BT = 0x30000058,
        PD_COMMS_API = 0x30000059,
        PD_COMMS_CLIENT_API = 0x3000005A,
        PDAPI = 0x3000005B,
        LSA_SUPL_DSM = 0x3000005C,
        TIME_REMOTE_MTOA = 0x3000005D,
        FTM_BT = 0x3000005E,
        DSUCSDAPPIF_APIS = 0x3000005F,
        PMAPP_GEN = 0x30000060,
        PM_LIB = 0x30000061,
        KEYPAD = 0x30000062,
        HSU_APP_APIS = 0x30000063,
        HSU_MDM_APIS = 0x30000064,
        ADIE_ADC_REMOTE_ATOM = 0x30000065,
        TLMM_REMOTE_ATOM = 0x30000066,
        UI_CALLCTRL = 0x30000067,
        UIUTILS = 0x30000068,
        PRL = 0x30000069,
        HW = 0x3000006A,
        OEM_RAPI = 0x3000006B,
        WMSPM = 0x3000006C,
        BTPF = 0x3000006D,
        CLKRGM_SYNC_EVENT = 0x3000006E,
        USB_APPS_RPC = 0x3000006F,
        USB_MODEM_RPC = 0x30000070,
        ADC = 0x30000071,
        CAMERAREMOTED = 0x30000072,
        SECAPIREMOTED = 0x30000073,
        DSATAPI = 0x30000074,
        CLKCTL_RPC = 0x30000075,
        BREWAPPCOORD = 0x30000076,
        WLAN_TRP_UTILS = 0x30000078,
        GPIO_RPC = 0x30000079,
        L1_DS = 0x3000007C,
        OSS_RRCASN_REMOTE = 0x3000007F,
        PMAPP_OTG_REMOTE = 0x30000080,
        PING_MDM_RPC = 0x30000081,
        WM_BTHCI_FTM = 0x30000084,
        WM_BT_PF = 0x30000085,
        IPA_IPC_APIS = 0x30000086,
        UKCC_IPC_APIS = 0x30000087,
        VBATT_REMOTE = 0x30000089,
        MFPAL_FPS = 0x3000008A,
        DSUMTSPDPREG = 0x3000008B,
        LOC_API = 0x3000008C,
        CMGAN = 0x3000008E,
        ISENSE = 0x3000008F,
        TIME_SECURE = 0x30000090,
        HS_REM = 0x30000091,
        ACDB = 0x30000092,
        NET = 0x30000093,
        LED = 0x30000094,
        DSPAE = 0x30000095,
        MFKAL = 0x30000096,
        TEST_API = 0x3000009B,
        REMOTEFS_SRV_API = 0x3000009C,
        ISI_TRANSPORT = 0x3000009D,
        OEM_FTM = 0x3000009E,
        TOUCH_SCREEN_ADC = 0x3000009F,
        SMD_BRIDGE_APPS = 0x300000A0,
        SMD_BRIDGE_MODEM = 0x300000A1,
    }

    public const uint32 OEM_RAPI_VERSION_1_0 = 0x00010000;
    public const uint32 OEM_RAPI_VERSION_1_1 = 0x00010001;

    public const uint32 OEM_RAPI_PROC_NULL = 0;
    public const uint32 OEM_RAPI_PROC_RPC_GLUE_CODE_INFO_REMOTE = 1;
    public const uint32 OEM_RAPI_PROC_STREAMING_FUNCTION = 2;

    enum OemRapiConstants
    {
        CLIENT_NULL_CB_ID = uint32.MAX,
    }

    public const uint32 OEM_RAPI_EVENT_HCI_EVENT = 0x2;
    public const uint32 OEM_RAPI_EVENT_HCI_CALLBACK = 0x3;
}
