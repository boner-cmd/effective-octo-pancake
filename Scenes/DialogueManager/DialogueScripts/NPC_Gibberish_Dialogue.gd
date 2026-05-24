extends MeshInstance3D
@export var current_state : DialogueManager.CONV_STATE = DialogueManager.CONV_STATE.PLAYER_LISTEN
@export var NPC_Normal_Template_Check : bool = true

#Dialogue goes here, 100 char per string limit, strongly suggest breaking it up if it can be
#gibberish dialogue
@export var initial_lines: Array[String] = [
	"iuewgf[iurh. f;;refijfk dnuew hfaoihdsu. dksjhfaoi ufye waifjdsn flkdsjfns.",
	"nvoiaiurysoo[dczos'cle,fmweaoewicjoiwanecec iewaocnewc ewacaeaiconewc iwaneoi edwdewaoin ewa.",
	"difniurehgiuefierne srifjiesvnfjdnkdknroiferuo sapdmpmfo;fjednceioncv:,",
	"kjfvifhroiueinfokrnvov oojdfkneokjrfoe rfeokdncoe;kf;sfknes rfism;f srefrmsekrf oxccscsr.",
]

@export var give_lines: Array[String] = [
	"NXOKZNOIDIFJCZXNCODINZC ZDIJFDKMFWOKPNENF XSPMODSK SKDMOKMDKSNPKAKNPZOFMSLKAFMPWEM",
	"XZHCLKJKDSLC KLSNJCZLK CLKDCZ,M'ASMCLS'LAJD;WQE ;FWKDNMSLKAD EWL;MDSND;SMQ;DNWD",
]

@export var receive_lines: Array[String] = [
	"xsockjcxoihfdzoxk ksjwfe'mfapfewafmea''a fekdlwad' diagonal line ;lsn'awieojdmkxz.",
]

@export var post_lines: Array[String] = [
	"sdksjfqwdsjf;f",
]

@export var easter_lines: Array[String] = [
	"osiczjspdihdscsdnc szdijcdscnzends lc fhdosijvcidssjzkndcmd dzsondcsz /cdz'sdvcdv dzs",
	"koxzckdsncvnds ccznoidsn;f cz;cndsoidsc zdzc;dsc/z .dz' c/dc dczl/knc zsdszkjdnfzsdnfds.",
	"lkdshfozncdszc jfdslfsbsdmfndsf dsjdksfds fdsoien[Wef nfzkefzdlks dkwadwdtskdasd awtdawdsa",
	"soaishdgdskofsd fdsjslkfdmpzn dskpsff zopdfjzof",
	"cmzskmzskc dzcmpsod djjxzoe fpsozcpdkzl dsl zfklknkdfjlkz xclcmlzknflxmckzx",
	"jkxhkfd",
	"xncosidjfodzx csodifjdsokfd lkjdshzeufsd dzkjsfhzsldyzkf elkszjfhlsudyk kjzhlerkjsc dkjzfyekr.",
	"oxkcnzsdjf czodjzsoijcdszlck kjzckzdsc dfhjluvcykzdf jhfudyfkndmdxnkjf vdkjfdzx cvzdfkjnflzf flvz",
]
