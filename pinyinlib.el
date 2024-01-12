;;; pinyinlib.el --- Convert first letter of Pinyin to Simplified/Traditional Chinese characters  -*- lexical-binding: t; -*-

;; Copyright (C) 2016  Junpeng Qiu

;; Author: Junpeng Qiu <qjpchmail@gmail.com>
;; Keywords: extensions

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;;                              ______________

;;                               PINYINLIB.EL

;;                               Junpeng Qiu
;;                              ______________


;; Table of Contents
;; _________________

;; 1 Functions
;; .. 1.1 `pinyinlib-build-regexp-char'
;; .. 1.2 `pinyinlib-build-regexp-string'
;; 2 Packages that Use This Library
;; 3 Acknowledgment
;; 4 Contribute


;; [[file:https://melpa.org/packages/pinyinlib-badge.svg]]
;; [[file:https://stable.melpa.org/packages/pinyinlib-badge.svg]]

;; Library for converting first letter of Pinyin to Simplified/Traditional
;; Chinese characters.


;; [[file:https://melpa.org/packages/pinyinlib-badge.svg]]
;; https://melpa.org/#/pinyinlib

;; [[file:https://stable.melpa.org/packages/pinyinlib-badge.svg]]
;; https://stable.melpa.org/#/pinyinlib


;; 1 Functions
;; ===========

;; 1.1 `pinyinlib-build-regexp-char'
;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

;;   `pinyinlib-build-regexp-char' converts a letter to a regular
;;   expression containing all the Chinese characters whose pinyins start
;;   with the letter.  It accepts five parameters:
;;   ,----
;;   | char &optional no-punc-p tranditional-p only-chinese-p mixed-p
;;   `----

;;   The first parameter `char' is the letter to be converted.  The latter
;;   four parameters are optional.
;;   - If `no-punc-p' is `t': it will not convert English punctuations to
;;     Chinese punctuations.

;;   - If `traditional-p' is `t': traditional Chinese characters are used
;;     instead of simplified Chinese characters.

;;   - If `only-chinese-p' is `t': the resulting regular expression doesn't
;;     contain the English letter `char'.

;;   - If `mixed-p' is `t': the resulting regular expression will mix
;;     traditional and simplified Chinese characters. This parameter will take
;;     precedence over `traditional-p'.

;;   When converting English punctuactions to Chinese/English punctuations,
;;   it uses the following table:
;;    English Punctuation  Chinese & English Punctuations
;;   -----------------------------------------------------
;;    .                    。.
;;    ,                    ，,
;;    ?                    ？?
;;    :                    ：:
;;    !                    ！!
;;    ;                    ；;
;;    \\                   、\\
;;    (                    （(
;;    )                    ）)
;;    <                    《<
;;    >                    》>
;;    ~                    ～~
;;    '                    ‘’「」'
;;    "                    “”『』\"
;;    *                    ×*
;;    $                    ￥$


;; 1.2 `pinyinlib-build-regexp-string'
;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

;;   It is same as `pinyinlib-build-regexp-char', except that its first
;;   parameter is a string so that it can convert a sequence of letters to
;;   a regular expression.


;; 2 Packages that Use This Library
;; ================================

;;   - [ace-pinyin]
;;   - [evil-find-char-pinyin]
;;   - [find-by-pinyin-dired]
;;   - [pinyin-search]


;; [ace-pinyin] https://github.com/cute-jumper/ace-pinyin

;; [evil-find-char-pinyin]
;; https://github.com/cute-jumper/evil-find-char-pinyin

;; [find-by-pinyin-dired]
;; https://github.com/redguardtoo/find-by-pinyin-dired

;; [pinyin-search] https://github.com/xuchunyang/pinyin-search.el


;; 3 Acknowledgment
;; ================

;;   - The ASCII char to Chinese character
;;     table(`pinyinlib--simplified-char-table' in code) is from
;;     [https://github.com/redguardtoo/find-by-pinyin-dired].
;;   - @erstern adds the table for traditional Chinese characters.


;; 4 Contribute
;; ============

;;   Contributions are always welcome.  If you want to add some common
;;   pinyin related functions that might be useful for other packages,
;;   please send me a PR.

;;; Code:
(require 'cl-lib)

(defgroup pinyinlib nil
  "The char table used by find char."
  :group 'convinience)

(defcustom pinyinlib-char-table-type
  'mix
  "Which char table type to use."
  :group 'pinyinlib
  :type '(choice :tag "Which char table to use"
                 (const :tag "Pinyin" pinyin)
                 (const :tag "Wubi" wubi)
                 (const :tag "Pinyin + Wubi" mix)))

(defconst pinyinlib--pinyin-simplified-char-table
  '("阿啊呵腌嗄锕吖爱哀挨碍埃癌艾唉矮哎皑蔼隘暧霭捱嗳瑷嫒锿嗌砹安案按暗岸俺谙黯鞍氨庵桉鹌胺铵揞犴埯昂肮盎奥澳傲熬敖凹袄懊坳嗷拗鏖骜鳌翱岙廒遨獒聱媪螯鏊"
    "把八吧巴爸罢拔叭芭霸靶扒疤跋坝笆耙粑灞茇菝魃岜捌钯鲅百白败摆伯拜柏呗掰捭佰稗办半版般班板伴搬扮斑颁瓣拌扳绊阪坂瘢钣舨癍帮邦棒膀榜傍绑磅谤浜梆镑蚌蒡报保包暴宝抱薄胞爆鲍饱堡曝刨褒豹雹苞葆褓孢煲鸨龅趵被北备背悲辈杯倍贝碑卑蓓惫悖狈呗焙鹎孛邶陂埤碚褙鐾鞴萆钡本奔笨苯夯畚贲锛坌崩甭绷蹦迸甏泵嘣蚌比必笔毕币避闭鼻彼逼壁臂弊碧鄙毙蔽庇匕璧敝陛弼篦婢愎痹妣濞铋裨俾髀萆薜哔狴庳秕滗舭毖吡嬖蓖贲畀荸埤筚箅芘襞跸荜编便边变遍辩辨贬鞭辫扁卞砭苄匾汴蝙笾碥窆褊弁鳊忭煸缏表标彪镖膘骠镳裱杓飙瘭髟飚婊飑鳔别憋瘪蹩鳖宾滨彬斌鬓缤殡濒槟摈膑傧玢豳髌镔并病兵冰饼丙柄秉炳禀邴摒波播博伯勃薄拨泊柏剥玻驳卜脖搏膊饽簸掰舶跛礴菠帛铂钵渤檗钹擘箔趵孛鹁踣亳啵不部布步补捕怖卜簿哺埔卟埠钸逋醭晡瓿钚"
    "擦嚓礤才采菜财材彩裁猜蔡踩睬参餐残惨灿惭掺蚕璨孱骖黪粲藏苍仓沧舱伧草操曹糙嘈槽螬艚漕策测侧厕册恻参岑涔曾层蹭噌查察差茶插刹叉诧茬碴喳岔嚓衩杈楂槎檫镲搽锸猹馇汊姹差柴拆豺钗侪虿瘥产颤缠禅蝉馋铲搀阐掺潺忏蟾婵谄谗廛孱澶冁躔蒇骣觇镡羼长场常唱厂尝昌肠偿畅倡倘敞怅娼猖嫦伥氅徜昶鲳阊菖苌鬯惝超朝潮炒吵抄嘲钞绰巢晁焯怊耖车彻撤扯澈掣坼砗称陈沉晨尘臣趁衬辰郴谶琛忱嗔伧抻谌宸榇龀碜成城程称承诚盛乘呈撑惩澄秤瞠橙噌逞铛丞骋埕枨塍铖裎酲柽蛏吃持迟尺赤斥池痴齿驰耻翅匙侈哧嗤啻弛蚩炽笞敕叱饬踟鸱褫豉坻墀茌篪傺媸螭彳眵魑瘛重冲充崇虫宠憧忡艟茺舂铳抽愁仇丑筹臭酬绸踌瞅惆畴稠雠俦帱瘳出处除初楚触储础厨畜躇橱雏矗怵锄杵搐绌黜褚蜍蹰刍滁楮憷亍樗揣啜踹嘬膪搋传穿川船串喘舛遄舡巛氚椽钏创窗床闯幢疮怆吹垂炊锤捶陲槌棰春纯唇蠢醇淳椿鹑蝽莼绰戳啜辍踔龊此次词差刺辞慈磁赐瓷兹茨雌祠疵呲鹚糍茈从匆聪丛葱囱琮淙枞苁骢璁凑楱辏腠促粗簇醋卒猝蹴蹙徂殂蔟酢攒窜篡蹿撺镩汆爨脆粹催摧崔萃翠瘁悴璀隹淬毳榱啐存村寸忖皴错措搓挫撮磋蹉矬嵯脞痤瘥鹾厝锉"
    "大打达答搭瘩嗒沓耷褡鞑笪靼怛妲哒疸代带待戴袋呆贷逮歹殆黛怠玳岱迨傣呔骀绐埭甙但单担弹淡旦蛋胆诞丹耽惮眈啖澹掸殚箪瘅赕疸聃氮萏郸儋当党荡档挡裆铛宕凼菪谠砀到道导倒岛刀悼盗蹈捣祷叨稻忉帱氘纛的得德锝等登灯邓凳瞪蹬噔磴戥镫簦嶝地第提底低帝弟敌抵递滴迪蒂堤笛缔涤嘀诋谛狄邸睇嫡翟砥娣棣荻羝坻柢觌骶氐绨镝碲籴嗲点电店典颠甸淀垫殿滇奠惦掂碘癫巅踮佃玷簟阽坫靛钿癜丶调掉吊雕刁钓凋叼貂碉铫铞鲷爹跌叠迭碟谍蝶喋佚踮牒耋蹀堞瓞揲垤鲽定订顶丁盯钉鼎叮町铤腚酊仃锭疔啶玎碇耵丢铥动东懂冬洞冻董栋咚恫侗氡硐鸫岽垌峒胨胴都斗豆抖逗兜陡窦蔸蚪篼痘都读度独毒督渡肚杜睹堵赌妒嘟渎笃牍镀犊黩髑椟芏蠹断段短端锻缎煅椴簖对队堆兑碓憝怼镦顿盾吨敦蹲钝炖遁盹沌囤墩趸镦礅砘多夺朵躲舵堕踱咄跺哆剁惰垛驮掇铎裰哚缍沲柁"
    "额俄恶饿哦鹅扼愕遏噩娥峨呃厄鄂讹婀蛾轭颚鳄锷谔屙锇阏垩腭苊鹗萼莪诶恩摁蒽而二儿尔耳迩饵洱鸸珥铒鲕贰佴"
    "发法罚乏伐阀砝筏垡珐反饭犯翻范凡烦返番贩繁泛帆藩幡梵樊燔蕃畈钒蘩矾蹯方放房访防仿芳妨纺彷坊肪舫钫鲂邡枋非费飞废肥啡沸菲肺匪诽腓扉吠霏绯妃斐翡蜚痱淝悱鲱篚芾狒镄榧分份纷奋愤粉氛芬坟焚粪忿吩汾棼鼢玢酚偾瀵鲼风封丰峰疯锋逢奉缝凤讽冯蜂枫烽俸砜唪酆葑沣佛否缶夫府服复父负副福富付妇附佛幅伏符赴腐浮扶腹抚覆肤赋弗傅辅拂甫俯斧缚咐脯袱俘敷阜芙釜孚腑匐孵辐涪讣氟桴蜉芾苻茯莩菔幞怫拊滏黼艴麸绂绋趺祓砩黻罘蚨跗蝠呋凫郛稃驸赙馥蝮鲋鳆"
    "咖尬嘎噶轧伽旮钆尕尜改该概盖丐钙赅溉垓陔戤感干敢赶甘肝杆尴赣橄竿秆擀坩苷柑泔矸澉疳酐淦绀旰刚港钢岗纲缸扛杠冈肛罡戆筻高告稿搞糕膏皋羔睾槁藁缟篙镐诰槔杲郜锆个革各歌格哥戈隔葛割阁胳搁疙咯鸽嗝骼颌屹搿膈镉纥袼仡鬲塥圪哿舸铬硌虼给根跟亘艮哏茛更耿耕颈庚羹梗哽赓鲠埂绠工公共供功攻宫贡恭巩躬龚弓拱肱汞蚣珙觥够购构狗沟勾苟钩觏篝垢佝岣诟鞲笱枸遘媾缑彀故古顾股鼓姑骨固孤谷估雇辜咕沽箍菇汩轱锢蛊梏鸪毂鹄臌瞽罟钴觚鹘菰蛄嘏诂崮酤牿牯痼鲴挂瓜刮寡呱褂卦剐鸹栝胍诖怪乖拐掴关观管官馆惯冠贯罐灌棺莞倌纶掼盥涫鳏鹳广光逛犷咣胱桄规归贵鬼桂跪柜轨瑰诡刽龟硅闺皈傀癸圭晷簋妫鲑匦庋宄炔刿桧炅鳜滚棍鲧绲磙辊衮国过果锅郭裹帼蝈聒馘掴埚虢呙崞猓椁蜾"
    "哈蛤铪还海孩害嘿咳亥骇骸嗨胲醢氦汉喊含寒汗韩憾涵函翰撼罕旱捍酣悍憨晗瀚鼾顸阚焊蚶焓颔菡撖邗邯行航巷杭夯沆颃绗珩好号毫豪浩耗皓嚎昊郝壕蒿貉灏镐嗥嚆薅濠蚝颢和何合河喝赫核吓贺盒呵禾荷鹤壑阂褐诃涸阖嗬貉曷颌劾盍纥蚵翮菏黑嘿嗨很恨狠痕横衡恒哼亨蘅珩桁红轰洪鸿哄宏虹弘烘泓闳薨讧蕻訇黉荭后候後厚侯喉吼猴逅糇骺堠瘊篌鲎乎护呼胡户湖忽互糊虎壶狐沪惚浒唬葫弧蝴囫瑚斛祜猢鹄醐戽扈唿笏琥滹鹕轷烀冱岵怙鹘槲觳瓠鹱煳话华化花划画滑哗桦猾砉铧骅怀坏徊淮槐踝欢换还环缓患幻唤宦焕痪寰鬟涣浣奂桓缳豢锾郇萑圜洹擐獾漶逭鲩黄皇荒晃慌煌惶恍谎璜徨簧凰幌潢蝗蟥遑隍肓磺癀湟篁鳇会回汇挥辉灰惠毁悔恢慧绘徽讳贿徊晦秽诲诙晖彗麾烩荟卉茴喙蛔恚洄珲蕙哕咴浍虺缋桧隳蟪婚混魂昏浑馄荤诨溷阍珲和或活火获货伙祸惑霍豁夥锪耠劐钬攉藿嚯镬蠖"
    ""
    "几给己机记及计即基济辑级极寄际技集纪击奇急激继既积籍鸡吉挤迹季寂绩疾饥祭缉忌剂圾姬矶肌嫉讥藉叽脊冀稽妓棘骥畸蓟汲悸岌伎笈跻瘠亟诘暨霁羁稷偈戟嵇楫唧鲫髻荠箕觊蒺畿虮齑殛墼佶掎芨丌麂蕺咭嵴芰笄哜洎乩戢屐剞跽玑鲚赍犄家加价假架甲佳驾夹嫁嘉贾稼茄佼挟颊皎侥枷珈戛迦伽浃痂胛笳荚葭钾镓嘏郏挢岬徼湫敫袈瘕恝铗袷蛱跏见间件建简坚监减渐检健兼剑艰肩键荐尖鉴剪践奸捡箭舰拣贱溅煎俭槛碱歼缄茧笺柬谏蹇僭涧菅謇硷睑锏饯毽鲣鞯蒹搛谫囝湔缣枧戬戋犍裥笕翦趼楗牮鹣腱踺将讲强江奖降蒋疆酱姜浆僵匠犟缰绛桨耩礓洚豇茳糨教交觉校叫较角脚焦骄郊轿搅嚼胶缴绞饺椒矫娇佼狡浇跤姣窖剿侥皎蕉酵礁鲛徼湫敫僬鹪峤蛟铰艽茭挢噍醮界解接结节街姐阶介借戒杰届皆捷截洁揭劫竭藉睫诫嗟拮孑碣秸诘桀芥偈颉讦疖疥婕羯鲒蚧骱喈进今金近尽仅紧禁劲津斤谨锦筋晋巾浸襟瑾矜靳缙烬噤觐馑堇衿荩廑妗卺赆槿经京精境警竟静惊景敬睛镜竞净井径晶荆兢颈憬靖鲸泾阱儆旌痉迳茎胫腈菁粳獍肼弪婧刭靓窘炯迥扃炅就九究酒久旧救纠揪疚舅韭赳鸠灸咎啾臼鹫阄僦厩玖柩桕鬏局据居句举具剧巨聚拒俱距惧菊拘矩桔驹鞠咀沮瞿锯炬飓趄掬踽踞遽橘倨疽龃屦犋裾钜苴雎鞫椐讵苣锔狙榘莒枸榉窭醵琚捐卷倦眷娟隽绢鹃涓镌锩鄄狷桊蠲觉绝决脚嚼掘诀崛爵抉倔獗嗟厥蹶攫谲矍撅噱孓橛噘珏桷劂爝镢蕨觖军均君俊峻钧隽筠菌郡骏竣麇皲捃浚"
    "卡咖喀咔佧胩开慨凯铠揩楷恺垲蒈锎剀锴忾看刊侃堪砍坎槛勘瞰龛阚莰戡抗康慷扛炕亢糠伉闶钪考靠铐烤拷犒栲尻可克科客刻课颗渴柯呵棵恪咳苛磕壳坷嗑瞌轲稞疴蝌溘髁钶窠颏珂岢骒缂氪锞蚵肯恳啃垦龈裉坑吭铿空恐控孔倥崆箜口扣抠寇叩蔻眍芤筘苦哭库裤酷枯窟骷刳堀喾绔夸跨垮挎胯侉会快块筷脍蒯哙侩狯浍郐款宽髋况狂矿框旷眶筐匡哐邝诓夼诳圹纩贶亏愧溃窥魁馈睽盔逵葵奎匮傀喟聩岿馗夔篑喹悝暌隗蒉蝰愦揆跬困昆捆坤鲲悃髡锟醌阃琨括阔扩廓栝蛞"
    "拉啦辣腊喇垃蜡剌邋旯瘌砬来赖莱睐癞籁徕涞赉铼崃濑兰蓝栏烂懒览滥拦篮揽澜榄婪缆斓岚阑褴镧罱谰漤浪狼朗郎廊琅螂榔啷莨锒稂阆蒗老劳牢捞姥佬潦唠烙酪涝崂痨醪铹栳铑耢了乐勒肋叻泐鳓仂类泪累雷蕾垒磊擂肋儡羸诔镭嘞檑嫘缧酹耒冷愣楞棱塄里理力利立李历离例礼丽励黎厉璃莉哩笠粒俐漓栗狸梨隶吏沥篱厘犁雳罹莅戾鲤俚砺藜俪蜊黧郦痢枥逦娌詈骊荔鳢喱鹂嫠蠡鬲鲡悝坜苈砾藓呖唳猁溧澧栎轹蓠傈缡疠疬蛎锂篥粝跞醴俩联连脸练恋怜莲廉炼帘链敛涟镰殓琏楝裢裣蠊鲢濂臁潋蔹奁两量良亮辆梁俩凉粮谅粱晾踉莨墚魉椋靓了料聊疗辽僚廖寥镣潦撩撂缭燎寮嘹钌獠鹩蓼尥列烈裂劣猎咧趔冽洌捩埒躐鬣林临邻琳淋霖麟凛吝鳞磷躏赁嶙辚檩遴粼蔺懔瞵啉膦廪领令另灵零龄凌玲铃陵岭拎伶聆囹棱菱翎苓瓴棂绫呤柃鲮酃泠羚蛉六留流陆刘溜柳碌瘤榴浏硫琉遛馏镏骝绺锍旒熘鎏鹨龙隆笼胧拢咙聋垄珑窿陇癃茏栊泷垅砻楼陋漏搂喽篓偻娄髅蝼镂蒌嵝耧瘘路陆录卢露鲁炉鹿碌庐芦噜颅禄辘卤虏麓泸赂漉戮簏轳鹭掳潞鲈撸栌垆胪蓼渌鸬逯璐辂橹镥舻氇律旅绿率虑履屡侣缕驴吕榈滤捋铝褛闾膂氯稆乱卵峦挛孪栾銮娈滦鸾脔略掠锊论轮伦沦仑抡囵纶落罗络洛逻裸骆萝螺锣箩摞烙捋珞骡猡镙椤倮蠃荦瘰泺漯脶硌雒"
    "呒马吗妈码麻骂嘛抹玛蚂蟆唛杩犸嬷买卖麦埋迈脉霾劢荬满慢漫曼蛮馒瞒蔓颟谩墁幔螨鞔鳗缦熳镘忙茫盲芒氓莽蟒邙漭硭毛冒猫贸矛帽貌茅茂髦卯耄瑁锚懋袤铆峁牦蟊泖昴茆旄蝥瞀么麽没美每妹眉梅媒枚魅煤昧霉玫媚寐糜袂酶莓嵋楣湄猸镅浼鹛镁们门闷扪懑焖钔梦蒙猛盟朦孟萌勐懵檬蠓瞢甍礞蜢虻艋艨锰密米秘迷弥谜觅眯蜜靡咪谧泌糜汨宓麋醚弭敉芈祢脒幂縻嘧蘼猕糸面免棉眠缅绵勉腼冕娩湎沔眄黾渑妙描秒庙苗渺瞄藐缪淼缈喵眇邈鹋杪灭蔑篾咩乜蠛民敏悯闽泯珉皿抿闵苠岷缗玟愍黾鳘名明命鸣铭冥茗溟酩瞑暝螟谬缪默莫模麽末磨摸摩寞漠墨抹魔陌嘿沫膜蓦蘑茉馍摹貉谟嫫秣镆殁瘼耱貊貘某谋眸缪鍪哞侔蛑目母木幕姆慕牧墓募暮牟亩穆睦拇沐牡仫坶苜毪钼"
    "嗯唔那拿呢哪纳娜呐捺钠镎肭衲乃奶奈耐氖艿鼐佴萘柰难南男楠喃囡囝腩蝻赧囊囔馕攮曩脑闹恼挠瑙淖呶猱铙孬硇蛲垴呢讷内馁嫩恁能嗯唔你呢尼泥逆倪匿拟腻妮霓昵溺旎睨鲵坭猊怩伲祢慝铌年念廿粘碾捻蔫撵拈黏鲶鲇辇埝娘酿鸟尿袅嬲茑脲捏涅聂孽蹑嗫啮镊镍乜陧颞臬蘖您恁宁凝拧泞咛狞柠佞聍苎甯牛纽扭妞钮拗忸狃农弄浓侬哝脓耨怒努奴弩驽胬孥女钕恧衄暖虐疟诺挪懦糯喏搦傩锘"
    "哦噢喔欧偶殴呕鸥讴瓯藕沤耦怄"
    "怕爬帕扒趴啪琶葩耙杷钯筢派排牌拍徘湃俳蒎哌判盘盼叛畔潘攀拚蹒磐爿蟠襻袢泮旁庞胖乓膀磅彷螃滂耪逄跑炮抛泡袍刨咆狍疱脬庖匏配陪培佩赔沛裴呸胚醅锫辔帔旆霈盆喷湓朋鹏碰彭捧棚蓬膨烹抨篷砰澎怦堋蟛嘭硼批否皮屁披疲辟啤脾匹僻劈譬坯痞癖琵毗霹噼媲郫裨纰丕鼙圮蚍蜱貔陂陴砒仳埤擗吡庀邳疋芘枇罴淠铍甓睥便片篇偏骗翩扁犏谝蹁骈缏胼票漂飘瓢嫖瞟骠嘌剽螵缥莩殍撇瞥氕丿苤品贫拼频聘拚姘嫔榀颦牝平评瓶凭萍乒屏苹坪枰娉俜鲆破迫颇婆坡泊泼魄粕珀叵攴钷笸钋陂泺鄱皤剖裒掊普铺扑朴谱浦葡蒲仆脯瀑菩溥匍璞噗圃埔氆镨蹼镤濮莆"
    "起其期气七奇妻企器汽棋齐旗弃启骑欺歧岂戚凄泣契琪乞祈漆迄脐栖沏祺崎祁琦蹊砌憩淇汔亟绮讫嘁岐萋俟杞芪荠耆槭颀芑屺欹桤綮萁蛴蜞綦鳍麒蕲柒亓骐葺畦圻碛恰洽掐伽袷葜髂前钱千签欠牵浅潜迁谦遣歉纤嵌乾谴铅虔钳骞倩堑黔掮悭芊缱愆荨芡阡佥搴褰肷钎仟犍钤岍箝鬈扦慊椠枪墙抢腔呛锵跄羌蔷戕襁樯炝蜣嫱锖戗羟镪桥悄乔巧侨瞧敲翘俏窍峭锹撬跷憔樵鞘橇诮愀谯荞峤缲硗鞒劁切且窃怯茄趄妾砌惬伽锲挈郄箧慊亲钦琴侵秦勤芹擒寝覃沁禽噙揿檎锓芩嗪螓衾廑溱吣情请青清轻晴庆倾卿擎顷氢罄蜻磬謦苘圊檠黥鲭氰箐綮穷琼穹茕邛蛩筇跫銎求球秋邱囚丘酋蚯裘俅虬鳅逑遒赇泅楸犰湫蝤巯鼽糗去取区曲趣屈趋驱渠躯娶觑瞿岖戌蛐衢蛆癯麴阒祛磲鸲诎蠼劬蕖蘧龋苣黢璩氍朐全权圈劝泉券拳犬诠颧蜷绻荃铨痊鬈辁悛畎醛筌却确缺雀瘸榷鹊阕阙炔悫群裙逡麇强"
    "然染燃冉髯苒蚺让嚷攘壤瓤穰禳扰绕饶娆桡荛热惹喏人任认忍仁韧刃纫饪壬仞稔葚荏妊轫衽仍扔日容荣融蓉溶绒熔榕戎嵘茸冗肜蝾狨肉柔揉蹂鞣糅如入辱儒乳汝褥嚅茹濡蠕孺缛襦颥薷蓐洳溽铷软阮朊瑞锐芮睿蕤枘蕊蚋润闰若弱偌箬"
    "洒撒萨卅仨飒挲脎赛塞腮噻鳃三散伞叁毵馓糁霰丧桑嗓搡磉颡扫骚嫂梢臊搔缲缫鳋埽瘙色塞涩瑟啬铯穑森僧杀沙啥傻厦刹纱莎煞砂霎嗄挲歃鲨唼痧裟铩晒筛酾山善闪衫删煽扇陕珊杉擅掺膳栅讪跚汕姗赡潸缮嬗掸膻骟芟埏剡钐鄯舢苫髟疝蟮鳝上商伤尚赏殇裳晌觞熵墒绱垧少绍烧稍勺哨邵梢捎韶苕鞘潲劭杓芍蛸筲艄社设舍涉射摄舌蛇奢赦慑佘赊麝畲厍滠歙猞谁什身深神参甚申审沈伸慎渗绅肾呻婶莘蜃葚娠渖矧诜砷糁谂椹胂哂生声省胜升圣盛剩牲绳甥笙渑眚嵊晟是时十事实使世市识始士师诗式失史视示食室势试石释施适氏驶饰尸拾逝湿誓狮嗜蚀嘘屎侍匙峙仕恃柿轼矢噬拭虱弑蓍埘莳炻谥鲥豕贳铈螫舐筮鲺酾手受收首授守售瘦寿兽狩绶艏书数术属输树述熟束署殊舒叔鼠疏淑抒薯梳暑竖蜀恕墅孰漱枢俞赎黍蔬曙倏庶戍塾澍姝纾秫毹殳疋菽丨沭摅腧刷耍唰率衰摔甩帅蟀涮栓拴闩双爽霜孀泷水谁税睡顺舜瞬吮说朔硕烁铄妁蒴槊搠四死思斯司似私丝寺撕肆厮嘶伺饲嗣祀巳驷鸶俟汜泗厶兕蛳咝姒澌缌耜笥锶送松宋诵耸颂讼悚怂忪淞菘崧嵩凇竦搜艘嗽擞馊薮嗾叟嗖溲飕锼瞍螋苏诉速素俗肃宿塑稣溯酥粟簌夙嗉谡僳愫涑蔌觫算酸蒜狻岁随虽碎遂祟隧髓邃穗隋绥睢荽燧谇眭濉孙损笋荪狲飧榫隼所索缩锁琐梭嗦唆挲娑睃唢嗍蓑羧桫"
    "他她它踏塔塌榻嗒蹋沓遢挞鳎闼铊趿漯溻獭太台态泰抬胎汰苔呔鲐邰薹酞骀炱跆肽钛谈探弹坦叹坛摊贪滩毯谭潭瘫炭覃痰忐坍袒碳澹檀昙镡郯锬钽堂唐汤躺糖趟倘烫淌膛塘棠搪溏螳瑭樘螗铴醣镗耥饧傥帑羰讨套逃涛掏陶桃淘滔萄焘啕韬饕洮绦鼗特忑忒慝铽忒腾疼藤誊滕体提题替踢梯啼涕蹄剔剃惕屉嚏悌醍缇鹈锑荑倜绨逖裼天田填甜添腆舔恬钿阗畋忝殄掭条调跳挑迢眺鲦佻苕窕髫粜笤龆祧蜩铁贴帖餮萜听停庭厅挺亭婷廷艇町霆汀铤蜓莛梃葶烃同通统痛童彤筒铜桶捅桐瞳佟恸酮恫侗砼嗵仝垌茼峒潼头投偷透钭骰土突图途徒屠涂吐兔秃凸荼酴钍菟堍团湍抟疃彖推退腿褪颓蜕忒煺吞屯饨褪臀囤豚暾氽托脱拖妥拓陀驼唾椭砣驮沱跎坨鸵乇鼍橐佗庹铊酡柁柝箨"
    ""
    ""
    "瓦挖袜娃哇凹娲蛙洼佤腽外歪崴万完晚湾玩碗弯挽顽腕婉惋宛丸蜿莞畹剜豌皖纨琬脘烷芄菀绾望王往网忘亡汪旺枉妄惘罔尢辋魍为位未委维味围卫威微伟谓唯危慰尾违魏玮蔚伪畏胃喂炜韦惟巍纬萎娓苇尉帷渭猥偎薇痿猬逶帏韪煨鲔桅潍隈圩囗诿隗崴洧葳嵬闱沩涠艉軎文问闻温稳吻纹蚊雯紊瘟汶刎阌璺翁瓮嗡蓊蕹我握窝卧渥沃涡斡蜗幄喔倭挝莴肟硪龌无五物务武午舞於误恶吴屋伍悟吾污乌雾侮捂巫毋呜诬勿梧坞戊兀唔晤芜鹜钨妩痦鹉忤寤骛邬牾鼯圬浯仵阢芴庑婺怃杌焐蜈迕鋈"
    "西系息希喜席习细戏吸洗惜稀悉析夕牺袭昔熙兮溪隙嘻锡晰媳樨熄膝郗犀禧曦奚羲蹊唏淅嬉皙汐徙茜玺熹烯翕蟋屣檄浠僖穸蜥隰觋螅铣菥葸蓰舾矽粞硒醯欷鼷歙饩阋禊舄下夏吓峡厦侠狭霞瞎暇虾唬辖遐匣黠瑕呷狎柙硖瘕罅现先显线险限县鲜献闲宪陷贤仙嫌咸羡掀弦纤娴衔馅涎舷腺跣暹岘猃蚬筅跹莶锨鹇痫铣氙祆籼冼藓酰苋燹霰想相向象香乡像响项享降箱详祥巷厢湘橡翔镶飨襄饷骧葙庠鲞芗缃蟓小笑校消效晓销潇肖萧孝宵削嚣啸逍硝霄淆哮枭骁箫筱哓枵绡魈蛸崤些写谢协鞋携斜泄胁歇谐邪械屑卸挟懈泻亵蟹偕邂榭撷楔瀣蝎颉勰薤燮躞缬獬绁廨榍渫心新信欣辛薪馨鑫芯衅昕忻锌歆镡囟行性形兴星型姓幸刑醒腥杏悻惺邢猩荇擤荥饧硎陉雄兄胸凶熊匈汹芎修休秀袖宿臭羞绣朽锈嗅咻貅髹馐庥鸺岫溴许续需须徐序虚绪吁蓄叙畜嘘恤絮浒墟旭婿栩戌诩胥酗煦砉盱糈醑顼勖洫溆圩蓿选宣旋悬券喧轩玄炫渲绚眩萱漩暄璇谖铉儇痃泫煊楦癣碹揎镟学血雪削穴谑靴薛踅噱泶鳕寻询训迅讯巡逊循旬熏勋驯荤殉醺巽徇埙荀峋洵薰汛郇曛窨恂獯浔鲟蕈浚"
    "玥亚压雅牙呀押涯讶鸦哑鸭崖丫芽衙轧痖睚娅蚜伢疋岈琊垭揠迓桠氩砑眼言严演研烟验延沿掩颜厌炎燕阎宴盐咽岩雁焰艳焉淹衍阉奄谚俨檐蜒彦腌焱晏唁妍砚嫣胭湮筵堰赝餍鼹芫偃魇闫崦厣剡恹阏兖郾琰罨鄢谳滟阽鼽酽菸样洋阳央杨养扬仰羊痒漾泱氧鸯秧殃恙疡烊佯鞅怏徉炀蛘要摇药耀遥邀腰姚咬尧谣瑶窑夭肴妖吆钥侥杳窈鹞曜舀铫幺爻徭繇鳐珧轺崾也业夜爷叶野页液耶咽曳拽揶噎烨冶椰掖腋谒邺靥晔铘一以意已义议医易衣艺依译移异益亦亿疑遗忆宜椅伊仪谊抑翼矣役艾乙溢毅蛇裔逸姨夷轶怡蚁弈倚翌颐疫绎彝咦佚奕熠贻漪诣迤弋懿呓驿咿揖旖屹痍薏噫镒刈沂臆缢邑胰猗羿钇舣劓仡酏佾埸诒圯荑壹挹嶷饴嗌峄怿悒铱欹殪黟苡肄镱瘗癔翊蜴眙翳因音引印银隐饮阴姻瘾吟寅殷淫茵荫尹蚓垠喑湮胤鄞氤霪圻铟狺吲夤堙龈洇茚窨应英影营迎硬映赢盈颖鹰婴蝇樱莹荧膺萤萦莺罂瀛楹缨颍嬴鹦瑛茔嘤璎荥撄郢瘿蓥滢潆媵哟唷用永拥勇涌踊泳庸佣咏俑雍恿甬臃邕镛痈壅鳙饔喁墉蛹慵有又由友游右油优邮幽尤忧犹悠幼诱佑黝攸呦酉柚鱿莠囿鼬铀卣猷牖铕疣蚰蝣釉蝤繇莜侑莸宥蚴尢于与语育余遇狱雨於欲预予鱼玉愈域誉吁宇寓豫愚舆粥郁喻羽娱裕愉禹浴馀御逾渔渝俞萸瑜隅驭迂揄圄谕榆屿淤毓虞禺谀妪腴峪竽芋妤臾欤龉觎盂昱煜熨燠窬蝓嵛狳伛俣舁圉庾菀蓣饫阈鬻瘐窳雩瘀纡聿钰鹆鹬蜮员元原院远愿园源圆怨缘援冤袁渊苑猿鸳辕垣媛沅橼芫爰螈鼋眢圜鸢箢塬垸掾瑗月乐越约阅跃曰悦岳粤钥刖瀹栎樾龠钺运云允韵晕孕匀蕴酝筠芸耘陨纭殒愠氲狁熨郓恽昀韫郧"
    "杂扎砸咋咂匝拶在再载灾仔宰哉栽崽甾咱赞暂攒簪糌瓒拶昝趱錾藏脏葬赃臧锗奘驵早造遭糟澡灶躁噪凿枣皂燥蚤藻缲唣则责泽择咋啧仄迮笮箦舴帻赜昃贼怎谮增赠憎缯罾甑锃炸扎咋诈乍眨渣札栅轧闸榨喳揸柞楂哳吒铡砟齄咤痄蚱摘债宅窄斋寨翟砦瘵战展站占沾斩辗粘盏崭瞻绽蘸湛詹毡栈谵搌旃长张章丈掌涨帐障账胀仗杖彰璋蟑樟瘴漳嶂鄣獐仉幛嫜着找照招朝赵召罩兆昭肇沼诏钊啁棹笊这着者折哲浙遮辙辄谪蔗蛰褶鹧锗磔摺蜇赭柘真阵镇震针珍圳振诊枕斟贞侦赈甄臻箴疹砧桢缜畛轸胗稹祯浈溱蓁椹榛朕鸩政正证整争征挣郑症睁徵蒸怔筝拯铮峥狰诤鲭钲帧之只知至制直治指支志职致值织纸止质执智置址枝秩植旨滞徵帜稚挚汁掷殖芝吱肢脂峙侄窒蜘趾炙痔咫芷栉枳踯桎帙栀祉轾贽痣豸卮轵埴陟郅黹忮彘骘酯摭絷跖膣雉鸷胝蛭踬祗觯中种重众终钟忠衷肿仲锺踵盅冢忪舯螽周州洲粥舟皱骤轴宙咒昼肘帚胄纣诌绉妯碡啁荮籀繇酎主住注助著逐诸朱驻珠祝猪筑竹煮嘱柱烛铸株瞩蛛伫拄贮洙诛褚铢箸蛀茱炷躅竺杼翥渚潴麈槠橥苎侏瘃疰邾舳抓爪拽嘬传专转赚撰砖篆啭馔颛装状壮庄撞妆幢桩奘僮戆追坠缀锥赘隹椎惴骓缒准谆窀肫着桌捉卓琢灼酌拙浊濯茁啄斫镯涿焯浞倬禚诼擢子自字资咨紫滋仔姿吱兹孜梓渍籽姊恣滓谘龇秭呲辎锱眦笫髭淄茈觜訾缁耔鲻嵫赀孳粢趑总宗纵踪综棕粽鬃偬腙枞走奏邹揍驺鲰诹陬鄹组足族祖租阻卒诅俎镞菹赚钻攥纂躜缵最罪嘴醉咀觜蕞尊遵樽鳟撙作做坐座左昨琢佐凿撮柞嘬怍胙唑笮阼祚酢")
  "ASCII char to simplifed Chinese characters.")

(defconst pinyinlib--pinyin-traditional-char-table
  '("阿啊呵醃嗄錒吖愛哀挨礙埃癌艾唉矮哎皚藹隘曖靄捱噯璦嬡鎄嗌砹安案按暗岸俺諳黯鞍氨庵桉鵪胺銨揞犴垵昂骯盎奧澳傲熬敖凹襖懊坳嗷拗鏖驁鰲翱嶴廒遨獒聱媼螯鏊"
    "把八吧巴爸罷拔叭芭霸靶扒疤跋壩笆耙粑灞茇菝魃岜捌鈀鮁百白敗擺伯拜柏唄掰捭佰稗辦半版般班板伴搬扮斑頒瓣拌扳絆阪阪瘢鈑舨癍幫邦棒膀榜傍綁磅謗浜梆鎊蚌蒡報保包暴寶抱薄胞爆鮑飽堡曝刨褒豹雹苞葆褓孢煲鴇齙趵被北備背悲輩杯倍貝碑卑蓓憊悖狽唄焙鵯孛邶陂埤碚褙鐾鞴萆鋇本奔笨苯夯畚賁錛坌崩甭繃蹦迸甏泵嘣蚌比必筆畢幣避閉鼻彼逼壁臂弊碧鄙斃蔽庇匕璧敝陛弼篦婢愎痹妣濞鉍裨俾髀萆薜嗶狴庳秕潷舭毖吡嬖蓖賁畀荸埤篳箅芘襞蹕蓽編便邊變遍辯辨貶鞭辮扁卞砭苄匾汴蝙籩碥窆褊弁鯿忭煸緶表標彪鏢膘驃鑣裱杓飆瘭髟飈婊颮鰾別憋癟蹩鱉賓濱彬斌鬢繽殯瀕檳擯臏儐玢豳髕鑌並病兵冰餅丙柄秉炳稟邴摒波播博伯勃薄撥泊柏剝玻駁卜脖搏膊餑簸掰舶跛礴菠帛鉑鉢渤檗鈸擘箔趵孛鵓踣亳啵不部布步補捕怖卜簿哺埔卟埠鈽逋醭晡瓿鈈"
    "擦嚓礤才採菜財材彩裁猜蔡踩睬參餐殘慘燦慚摻蠶璨孱驂黲粲藏蒼倉滄艙傖草操曹糙嘈槽螬艚漕策測側廁冊惻參岑涔曾層蹭噌查察差茶插剎叉詫茬碴喳岔嚓衩杈楂槎檫鑔搽鍤猹餷汊奼差柴拆豺釵儕蠆瘥產顫纏禪蟬饞鏟攙闡摻潺懺蟾嬋諂讒廛孱澶囅躔蕆驏覘鐔羼長場常唱廠嘗昌腸償暢倡倘敞悵娼猖嫦倀氅徜昶鯧閶菖萇鬯惝超朝潮炒吵抄嘲鈔綽巢晁焯怊耖車徹撤扯澈掣坼硨稱陳沉晨塵臣趁襯辰郴讖琛忱嗔傖抻諶宸櫬齔磣成城程稱承誠盛乘呈撐懲澄秤瞠橙噌逞鐺丞騁埕棖塍鋮裎酲檉蟶吃持遲尺赤斥池癡齒馳恥翅匙侈哧嗤啻弛蚩熾笞敕叱飭踟鴟褫豉坻墀茌篪傺媸螭彳眵魑瘛重衝充崇蟲寵憧忡艟茺舂銃抽愁仇醜籌臭酬綢躊瞅惆疇稠讎儔幬瘳出處除初楚觸儲礎廚畜躇櫥雛矗怵鋤杵搐絀黜褚蜍躕芻滁楮憷亍樗揣啜踹嘬膪搋傳穿川船串喘舛遄舡巛氚椽釧創窗牀闖幢瘡愴吹垂炊錘捶陲槌棰春純脣蠢醇淳椿鶉蝽蓴綽戳啜輟踔齪此次詞差刺辭慈磁賜瓷茲茨雌祠疵呲鶿餈茈從匆聰叢蔥囪琮淙樅蓯驄璁湊楱輳腠促粗簇醋卒猝蹴蹙徂殂蔟酢攢竄篡躥攛鑹汆爨脆粹催摧崔萃翠瘁悴璀隹淬毳榱啐存村寸忖皴錯措搓挫撮磋蹉矬嵯脞痤瘥鹺厝銼"
    "大打達答搭瘩嗒沓耷褡韃笪靼怛妲噠疸代帶待戴袋呆貸逮歹殆黛怠玳岱迨傣呔駘紿埭甙但單擔彈淡旦蛋膽誕丹耽憚眈啖澹撣殫簞癉賧疸聃氮萏鄲儋當黨蕩檔擋襠鐺宕凼菪讜碭到道導倒島刀悼盜蹈搗禱叨稻忉幬氘纛的得德鍀等登燈鄧凳瞪蹬噔磴戥鐙簦嶝地第提底低帝弟敵抵遞滴迪蒂堤笛締滌嘀詆諦狄邸睇嫡翟砥娣棣荻羝坻柢覿骶氐綈鏑碲糴嗲點電店典顛甸澱墊殿滇奠惦掂碘癲巔踮佃玷簟阽坫靛鈿癜丶調掉吊雕刁釣凋叼貂碉銚銱鯛爹跌疊迭碟諜蝶喋佚踮牒耋蹀堞瓞揲垤鰈定訂頂丁盯釘鼎叮町鋌腚酊仃錠疔啶玎碇耵丟銩動東懂冬洞凍董棟咚恫侗氡硐鶇崬垌峒腖胴都鬥豆抖逗兜陡竇蔸蚪篼痘都讀度獨毒督渡肚杜睹堵賭妒嘟瀆篤牘鍍犢黷髑櫝芏蠹斷段短端鍛緞煅椴籪對隊堆兌碓憝懟鐓頓盾噸敦蹲鈍燉遁盹沌囤墩躉鐓礅砘多奪朵躲舵墮踱咄跺哆剁惰垛馱掇鐸裰哚綞沲柁"
    "額俄惡餓哦鵝扼愕遏噩娥峨呃厄鄂訛婀蛾軛顎鱷鍔諤屙鋨閼堊齶苊鶚萼莪誒恩摁蒽而二兒爾耳邇餌洱鴯珥鉺鮞貳佴"
    "發法罰乏伐閥砝筏垡琺反飯犯翻範凡煩返番販繁泛帆藩幡梵樊燔蕃畈釩蘩礬蹯方放房訪防仿芳妨紡彷坊肪舫鈁魴邡枋非費飛廢肥啡沸菲肺匪誹腓扉吠霏緋妃斐翡蜚痱淝悱鯡篚芾狒鐨榧分份紛奮憤粉氛芬墳焚糞忿吩汾棼鼢玢酚僨瀵鱝風封豐峯瘋鋒逢奉縫鳳諷馮蜂楓烽俸碸唪酆葑灃佛否缶夫府服復父負副福富付婦附佛幅伏符赴腐浮扶腹撫覆膚賦弗傅輔拂甫俯斧縛咐脯袱俘敷阜芙釜孚腑匐孵輻涪訃氟桴蜉芾苻茯莩菔襆怫拊滏黼艴麩紱紼趺祓砩黻罘蚨跗蝠呋鳧郛稃駙賻馥蝮鮒鰒"
    "咖尬嘎噶軋伽旮釓尕尜改該概蓋丐鈣賅溉垓陔戤感幹敢趕甘肝杆尷贛橄竿稈擀坩苷柑泔矸澉疳酐淦紺旰剛港鋼崗綱缸扛槓岡肛罡戇筻高告稿搞糕膏皋羔睾槁藁縞篙鎬誥槔杲郜鋯個革各歌格哥戈隔葛割閣胳擱疙咯鴿嗝骼頜屹搿膈鎘紇袼仡鬲塥圪哿舸鉻硌虼給根跟亙艮哏茛更耿耕頸庚羹梗哽賡鯁埂綆工公共供功攻宮貢恭鞏躬龔弓拱肱汞蚣珙觥夠購構狗溝勾苟鉤覯篝垢佝岣詬韝笱枸遘媾緱彀故古顧股鼓姑骨固孤谷估僱辜咕沽箍菇汩軲錮蠱梏鴣轂鵠臌瞽罟鈷觚鶻菰蛄嘏詁崮酤牿牯痼鯝掛瓜刮寡呱褂卦剮鴰栝胍詿怪乖拐摑關觀管官館慣冠貫罐灌棺莞倌綸摜盥涫鰥鸛廣光逛獷咣胱桄規歸貴鬼桂跪櫃軌瑰詭劊龜硅閨皈傀癸圭晷簋嬀鮭匭庋宄炔劌檜炅鱖滾棍鯀緄磙輥袞國過果鍋郭裹幗蟈聒馘摑堝虢咼崞猓槨蜾"
    "哈蛤鉿還海孩害嘿咳亥駭骸嗨胲醢氦漢喊含寒汗韓憾涵函翰撼罕旱捍酣悍憨晗瀚鼾頇闞焊蚶焓頷菡撖邗邯行航巷杭夯沆頏絎珩好號毫豪浩耗皓嚎昊郝壕蒿貉灝鎬嗥嚆薅濠蠔顥和何合河喝赫核嚇賀盒呵禾荷鶴壑閡褐訶涸闔嗬貉曷頜劾盍紇蚵翮菏黑嘿嗨很恨狠痕橫衡恆哼亨蘅珩桁紅轟洪鴻哄宏虹弘烘泓閎薨訌蕻訇黌葒後候後厚侯喉吼猴逅餱骺堠瘊篌鱟乎護呼胡戶湖忽互糊虎壺狐滬惚滸唬葫弧蝴囫瑚斛祜猢鵠醐戽扈唿笏琥滹鶘軤烀冱岵怙鶻槲觳瓠鸌煳話華化花劃畫滑譁樺猾砉鏵驊懷壞徊淮槐踝歡換還環緩患幻喚宦煥瘓寰鬟渙浣奐桓繯豢鍰郇萑圜洹擐獾漶逭鯇黃皇荒晃慌煌惶恍謊璜徨簧凰幌潢蝗蟥遑隍肓磺癀湟篁鰉會回匯揮輝灰惠毀悔恢慧繪徽諱賄徊晦穢誨詼暉彗麾燴薈卉茴喙蛔恚洄琿蕙噦咴澮虺繢檜隳蟪婚混魂昏渾餛葷諢溷閽琿和或活火獲貨夥禍惑霍豁夥鍃耠劐鈥攉藿嚯鑊蠖"
    ""
    "幾給己機記及計即基濟輯級極寄際技集紀擊奇急激繼既積籍雞吉擠跡季寂績疾飢祭緝忌劑圾姬磯肌嫉譏藉嘰脊冀稽妓棘驥畸薊汲悸岌伎笈躋瘠亟詰暨霽羈稷偈戟嵇楫唧鯽髻薺箕覬蒺畿蟣齏殛墼佶掎芨丌麂蕺咭嵴芰笄嚌洎乩戢屐剞跽璣鱭齎犄家加價假架甲佳駕夾嫁嘉賈稼茄佼挾頰皎僥枷珈戛迦伽浹痂胛笳莢葭鉀鎵嘏郟撟岬徼湫敫袈瘕恝鋏袷蛺跏見間件建簡堅監減漸檢健兼劍艱肩鍵薦尖鑑剪踐奸撿箭艦揀賤濺煎儉檻鹼殲緘繭箋柬諫蹇僭澗菅謇鹼瞼鐧餞毽鰹韉蒹搛譾囝湔縑梘戩戔犍襇筧翦趼楗牮鶼腱踺將講強江獎降蔣疆醬姜漿僵匠犟繮絳槳耩礓洚豇茳糨教交覺校叫較角腳焦驕郊轎攪嚼膠繳絞餃椒矯嬌佼狡澆跤姣窖剿僥皎蕉酵礁鮫徼湫敫僬鷦嶠蛟鉸艽茭撟噍醮界解接結節街姐階介借戒傑屆皆捷截潔揭劫竭藉睫誡嗟拮孑碣秸詰桀芥偈頡訐癤疥婕羯鮚蚧骱喈進今金近盡僅緊禁勁津斤謹錦筋晉巾浸襟瑾矜靳縉燼噤覲饉堇衿藎廑妗巹贐槿經京精境警竟靜驚景敬睛鏡競淨井徑晶荊兢頸憬靖鯨涇阱儆旌痙逕莖脛腈菁粳獍肼弳婧剄靚窘炯迥扃炅就九究酒久舊救糾揪疚舅韭赳鳩灸咎啾臼鷲鬮僦廄玖柩桕鬏局據居句舉具劇巨聚拒俱距懼菊拘矩桔駒鞠咀沮瞿鋸炬颶趄掬踽踞遽橘倨疽齟屨犋裾鉅苴雎鞫椐詎苣鋦狙榘莒枸櫸窶醵琚捐卷倦眷娟雋絹鵑涓鐫錈鄄狷桊蠲覺絕決腳嚼掘訣崛爵抉倔獗嗟厥蹶攫譎矍撅噱孓橛噘珏桷劂爝钁蕨觖軍均君俊峻鈞雋筠菌郡駿竣麇皸捃浚"
    "卡咖喀咔佧胩開慨凱鎧揩楷愷塏蒈鐦剴鍇愾看刊侃堪砍坎檻勘瞰龕闞莰戡抗康慷扛炕亢糠伉閌鈧考靠銬烤拷犒栲尻可克科客刻課顆渴柯呵棵恪咳苛磕殼坷嗑瞌軻稞痾蝌溘髁鈳窠頦珂岢騍緙氪錁蚵肯懇啃墾齦裉坑吭鏗空恐控孔倥崆箜口扣摳寇叩蔻瞘芤筘苦哭庫褲酷枯窟骷刳堀嚳絝誇跨垮挎胯侉會快塊筷膾蒯噲儈獪澮鄶款寬髖況狂礦框曠眶筐匡哐鄺誆夼誑壙纊貺虧愧潰窺魁饋睽盔逵葵奎匱傀喟聵巋馗夔簣喹悝暌隗蕢蝰憒揆跬困昆捆坤鯤悃髡錕醌閫琨括闊擴廓栝蛞"
    "拉啦辣臘喇垃蠟剌邋旯瘌砬來賴萊睞癩籟徠淶賚錸崍瀨蘭藍欄爛懶覽濫攔籃攬瀾欖婪纜斕嵐闌襤鑭罱讕灠浪狼朗郎廊琅螂榔啷莨鋃稂閬蒗老勞牢撈姥佬潦嘮烙酪澇嶗癆醪鐒栳銠耮了樂勒肋叻泐鰳仂類淚累雷蕾壘磊擂肋儡羸誄鐳嘞檑嫘縲酹耒冷愣楞棱塄裏理力利立李歷離例禮麗勵黎厲璃莉哩笠粒俐漓慄狸梨隸吏瀝籬釐犁靂罹蒞戾鯉俚礪藜儷蜊黧酈痢櫪邐娌詈驪荔鱧喱鸝嫠蠡鬲鱺悝壢藶礫蘚嚦唳猁溧澧櫟轢蘺傈縭癘癧蠣鋰篥糲躒醴倆聯連臉練戀憐蓮廉煉簾鏈斂漣鐮殮璉楝褳襝蠊鰱濂臁瀲蘞奩兩量良亮輛樑倆涼糧諒粱晾踉莨墚魎椋靚了料聊療遼僚廖寥鐐潦撩撂繚燎寮嘹釕獠鷯蓼尥列烈裂劣獵咧趔冽洌捩埒躐鬣林臨鄰琳淋霖麟凜吝鱗磷躪賃嶙轔檁遴粼藺懍瞵啉膦廩領令另靈零齡凌玲鈴陵嶺拎伶聆囹棱菱翎苓瓴欞綾呤柃鯪酃泠羚蛉六留流陸劉溜柳碌瘤榴瀏硫琉遛餾鎦騮綹鋶旒熘鎏鷚龍隆籠朧攏嚨聾壟瓏窿隴癃蘢櫳瀧壠礱樓陋漏摟嘍簍僂婁髏螻鏤蔞嶁耬瘻路陸錄盧露魯爐鹿碌廬蘆嚕顱祿轆滷虜麓瀘賂漉戮簏轤鷺擄潞鱸擼櫨壚臚蓼淥鸕逯璐輅櫓鑥艫氌律旅綠率慮履屢侶縷驢呂櫚濾捋鋁褸閭膂氯穭亂卵巒攣孿欒鑾孌灤鸞臠略掠鋝論輪倫淪侖掄圇綸落羅絡洛邏裸駱蘿螺鑼籮摞烙捋珞騾玀鏍欏倮蠃犖瘰濼漯腡硌雒"
    "嘸馬嗎媽碼麻罵嘛抹瑪螞蟆嘜榪獁嬤買賣麥埋邁脈霾勱蕒滿慢漫曼蠻饅瞞蔓顢謾墁幔蟎鞔鰻縵熳鏝忙茫盲芒氓莽蟒邙漭硭毛冒貓貿矛帽貌茅茂髦卯耄瑁錨懋袤鉚峁氂蟊泖昴茆旄蝥瞀麼麼沒美每妹眉梅媒枚魅煤昧黴玫媚寐糜袂酶莓嵋楣湄猸鎇浼鶥鎂們門悶捫懣燜鍆夢蒙猛盟朦孟萌勐懵檬蠓瞢甍礞蜢虻艋艨錳密米祕迷彌謎覓眯蜜靡咪謐泌糜汨宓麋醚弭敉羋禰脒冪縻嘧蘼獼糸面免棉眠緬綿勉靦冕娩湎沔眄黽澠妙描秒廟苗渺瞄藐繆淼緲喵眇邈鶓杪滅蔑篾咩乜蠛民敏憫閩泯珉皿抿閔苠岷緡玟愍黽鰵名明命鳴銘冥茗溟酩瞑暝螟謬繆默莫模麼末磨摸摩寞漠墨抹魔陌嘿沫膜驀蘑茉饃摹貉謨嫫秣鏌歿瘼耱貊貘某謀眸繆鍪哞侔蛑目母木幕姆慕牧墓募暮牟畝穆睦拇沐牡仫坶苜毪鉬"
    "嗯唔那拿呢哪納娜吶捺鈉鎿肭衲乃奶奈耐氖艿鼐佴萘柰難南男楠喃囡囝腩蝻赧囊囔饢攮曩腦鬧惱撓瑙淖呶猱鐃孬硇蟯堖呢訥內餒嫩恁能嗯唔你呢尼泥逆倪匿擬膩妮霓昵溺旎睨鯢坭猊怩伲禰慝鈮年念廿粘碾捻蔫攆拈黏鯰鯰輦埝娘釀鳥尿嫋嬲蔦脲捏涅聶孽躡囁齧鑷鎳乜隉顳臬櫱您恁寧凝擰濘嚀獰檸佞聹苧甯牛紐扭妞鈕拗忸狃農弄濃儂噥膿耨怒努奴弩駑胬孥女釹恧衄暖虐瘧諾挪懦糯喏搦儺鍩"
    "哦噢喔歐偶毆嘔鷗謳甌藕漚耦慪"
    "怕爬帕扒趴啪琶葩耙杷鈀筢派排牌拍徘湃俳蒎哌判盤盼叛畔潘攀拚蹣磐爿蟠襻袢泮旁龐胖乓膀磅彷螃滂耪逄跑炮拋泡袍刨咆狍皰脬庖匏配陪培佩賠沛裴呸胚醅錇轡帔旆霈盆噴湓朋鵬碰彭捧棚蓬膨烹抨篷砰澎怦堋蟛嘭硼批否皮屁披疲闢啤脾匹僻劈譬坯痞癖琵毗霹噼媲郫裨紕丕鼙圮蚍蜱貔陂陴砒仳埤擗吡庀邳疋芘枇羆淠鈹甓睥便片篇偏騙翩扁犏諞蹁駢緶胼票漂飄瓢嫖瞟驃嘌剽螵縹莩殍撇瞥氕丿苤品貧拼頻聘拚姘嬪榀顰牝平評瓶憑萍乒屏蘋坪枰娉俜鮃破迫頗婆坡泊潑魄粕珀叵攴鉕笸釙陂濼鄱皤剖裒掊普鋪撲樸譜浦葡蒲僕脯瀑菩溥匍璞噗圃埔氆鐠蹼鏷濮莆"
    "起其期氣七奇妻企器汽棋齊旗棄啓騎欺歧豈戚悽泣契琪乞祈漆迄臍棲沏祺崎祁琦蹊砌憩淇汔亟綺訖嘁岐萋俟杞芪薺耆槭頎芑屺欹榿綮萁蠐蜞綦鰭麒蘄柒亓騏葺畦圻磧恰洽掐伽袷葜髂前錢千籤欠牽淺潛遷謙遣歉纖嵌乾譴鉛虔鉗騫倩塹黔掮慳芊繾愆蕁芡阡僉搴褰肷釺仟犍鈐岍箝鬈扦慊槧槍牆搶腔嗆鏘蹌羌薔戕襁檣熗蜣嬙錆戧羥鏹橋悄喬巧僑瞧敲翹俏竅峭鍬撬蹺憔樵鞘橇誚愀譙蕎嶠繰磽鞽劁切且竊怯茄趄妾砌愜伽鍥挈郄篋慊親欽琴侵秦勤芹擒寢覃沁禽噙撳檎鋟芩嗪螓衾廑溱唚情請青清輕晴慶傾卿擎頃氫罄蜻磬謦檾圊檠黥鯖氰箐綮窮瓊穹煢邛蛩筇跫銎求球秋邱囚丘酋蚯裘俅虯鰍逑遒賕泅楸犰湫蝤巰鼽糗去取區曲趣屈趨驅渠軀娶覷瞿嶇戌蛐衢蛆癯麴闃祛磲鴝詘蠼劬蕖蘧齲苣黢璩氍朐全權圈勸泉券拳犬詮顴蜷綣荃銓痊鬈輇悛畎醛筌卻確缺雀瘸榷鵲闋闕炔愨羣裙逡麇強"
    "然染燃冉髯苒蚺讓嚷攘壤瓤穰禳擾繞饒嬈橈蕘熱惹喏人任認忍仁韌刃紉飪壬仞稔葚荏妊軔衽仍扔日容榮融蓉溶絨熔榕戎嶸茸冗肜蠑狨肉柔揉蹂鞣糅如入辱儒乳汝褥嚅茹濡蠕孺縟襦顬薷蓐洳溽銣軟阮朊瑞銳芮睿蕤枘蕊蚋潤閏若弱偌箬"
    "灑撒薩卅仨颯挲脎賽塞腮噻鰓三散傘叄毿饊糝霰喪桑嗓搡磉顙掃騷嫂梢臊搔繰繅鰠埽瘙色塞澀瑟嗇銫穡森僧殺沙啥傻廈剎紗莎煞砂霎嗄挲歃鯊唼痧裟鎩曬篩釃山善閃衫刪煽扇陝珊杉擅摻膳柵訕跚汕姍贍潸繕嬗撣羶騸芟埏剡釤鄯舢苫髟疝蟮鱔上商傷尚賞殤裳晌觴熵墒鞝垧少紹燒稍勺哨邵梢捎韶苕鞘潲劭杓芍蛸筲艄社設舍涉射攝舌蛇奢赦懾佘賒麝畲厙灄歙猞誰什身深神參甚申審沈伸慎滲紳腎呻嬸莘蜃葚娠瀋矧詵砷糝諗椹胂哂生聲省勝升聖盛剩牲繩甥笙澠眚嵊晟是時十事實使世市識始士師詩式失史視示食室勢試石釋施適氏駛飾屍拾逝溼誓獅嗜蝕噓屎侍匙峙仕恃柿軾矢噬拭蝨弒蓍塒蒔炻諡鰣豕貰鈰螫舐筮鯴釃手受收首授守售瘦壽獸狩綬艏書數術屬輸樹述熟束署殊舒叔鼠疏淑抒薯梳暑豎蜀恕墅孰漱樞俞贖黍蔬曙倏庶戍塾澍姝紓秫毹殳疋菽丨沭攄腧刷耍唰率衰摔甩帥蟀涮栓拴閂雙爽霜孀瀧水誰稅睡順舜瞬吮說朔碩爍鑠妁蒴槊搠四死思斯司似私絲寺撕肆廝嘶伺飼嗣祀巳駟鷥俟汜泗厶兕螄噝姒澌緦耜笥鍶送鬆宋誦聳頌訟悚慫忪淞菘崧嵩凇竦搜艘嗽擻餿藪嗾叟嗖溲颼鎪瞍螋蘇訴速素俗肅宿塑穌溯酥粟簌夙嗉謖僳愫涑蔌觫算酸蒜狻歲隨雖碎遂祟隧髓邃穗隋綏睢荽燧誶眭濉孫損筍蓀猻飧榫隼所索縮鎖瑣梭嗦唆挲娑睃嗩嗍蓑羧桫"
    "他她它踏塔塌榻嗒蹋沓遢撻鰨闥鉈趿漯溻獺太臺態泰擡胎汰苔呔鮐邰薹酞駘炱跆肽鈦談探彈坦嘆壇攤貪灘毯譚潭癱炭覃痰忐坍袒碳澹檀曇鐔郯錟鉭堂唐湯躺糖趟倘燙淌膛塘棠搪溏螳瑭樘螗鐋醣鏜耥餳儻帑羰討套逃濤掏陶桃淘滔萄燾啕韜饕洮絛鞀特忑忒慝鋱忒騰疼藤謄滕體提題替踢梯啼涕蹄剔剃惕屜嚏悌醍緹鵜銻荑倜綈逖裼天田填甜添腆舔恬鈿闐畋忝殄掭條調跳挑迢眺鰷佻苕窕髫糶笤齠祧蜩鐵貼帖餮萜聽停庭廳挺亭婷廷艇町霆汀鋌蜓莛梃葶烴同通統痛童彤筒銅桶捅桐瞳佟慟酮恫侗砼嗵仝垌茼峒潼頭投偷透鈄骰土突圖途徒屠塗吐兔禿凸荼酴釷菟堍團湍摶疃彖推退腿褪頹蛻忒煺吞屯飩褪臀囤豚暾氽託脫拖妥拓陀駝唾橢砣馱沱跎坨鴕乇鼉橐佗庹鉈酡柁柝籜"
    ""
    ""
    "瓦挖襪娃哇凹媧蛙窪佤膃外歪崴萬完晚灣玩碗彎挽頑腕婉惋宛丸蜿莞畹剜豌皖紈琬脘烷芄菀綰望王往網忘亡汪旺枉妄惘罔尢輞魍爲位未委維味圍衛威微偉謂唯危慰尾違魏瑋蔚僞畏胃喂煒韋惟巍緯萎娓葦尉帷渭猥偎薇痿蝟逶幃韙煨鮪桅濰隈圩囗諉隗崴洧葳嵬闈潙潿艉軎文問聞溫穩吻紋蚊雯紊瘟汶刎閿璺翁甕嗡蓊蕹我握窩臥渥沃渦斡蝸幄喔倭撾萵肟硪齷無五物務武午舞於誤惡吳屋伍悟吾污烏霧侮捂巫毋嗚誣勿梧塢戊兀唔晤蕪鶩鎢嫵痦鵡忤寤騖鄔牾鼯圬浯仵阢芴廡婺憮杌焐蜈迕鋈"
    "西系息希喜席習細戲吸洗惜稀悉析夕犧襲昔熙兮溪隙嘻錫晰媳樨熄膝郗犀禧曦奚羲蹊唏淅嬉皙汐徙茜璽熹烯翕蟋屣檄浠僖穸蜥隰覡螅銑菥葸蓰舾矽粞硒醯欷鼷歙餼鬩禊舄下夏嚇峽廈俠狹霞瞎暇蝦唬轄遐匣黠瑕呷狎柙硤瘕罅現先顯線險限縣鮮獻閒憲陷賢仙嫌鹹羨掀弦纖嫻銜餡涎舷腺跣暹峴獫蜆筅躚薟杴鷳癇銑氙祆秈冼蘚醯莧燹霰想相向象香鄉像響項享降箱詳祥巷廂湘橡翔鑲饗襄餉驤葙庠鯗薌緗蟓小笑校消效曉銷瀟肖蕭孝宵削囂嘯逍硝霄淆哮梟驍簫筱嘵枵綃魈蛸崤些寫謝協鞋攜斜泄脅歇諧邪械屑卸挾懈瀉褻蟹偕邂榭擷楔瀣蠍頡勰薤燮躞纈獬紲廨榍渫心新信欣辛薪馨鑫芯釁昕忻鋅歆鐔囟行性形興星型姓幸刑醒腥杏悻惺邢猩荇擤滎餳硎陘雄兄胸兇熊匈洶芎修休秀袖宿臭羞繡朽鏽嗅咻貅髹饈庥鵂岫溴許續需須徐序虛緒籲蓄敘畜噓恤絮滸墟旭婿栩戌詡胥酗煦砉盱糈醑頊勖洫漵圩蓿選宣旋懸券喧軒玄炫渲絢眩萱漩暄璇諼鉉儇痃泫煊楦癬碹揎鏇學血雪削穴謔靴薛踅噱澩鱈尋詢訓迅訊巡遜循旬薰勳馴葷殉醺巽徇塤荀峋洵薰汛郇曛窨恂獯潯鱘蕈浚"
    "玥亞壓雅牙呀押涯訝鴉啞鴨崖丫芽衙軋瘂睚婭蚜伢疋岈琊埡揠迓椏氬砑眼言嚴演研煙驗延沿掩顏厭炎燕閻宴鹽咽巖雁焰豔焉淹衍閹奄諺儼檐蜒彥醃焱晏唁妍硯嫣胭湮筵堰贗饜鼴芫偃魘閆崦厴剡懨閼兗郾琰罨鄢讞灩阽鼽釅菸樣洋陽央楊養揚仰羊癢漾泱氧鴦秧殃恙瘍烊佯鞅怏徉煬蛘要搖藥耀遙邀腰姚咬堯謠瑤窯夭餚妖吆鑰僥杳窈鷂曜舀銚幺爻徭繇鰩珧軺崾也業夜爺葉野頁液耶咽曳拽揶噎燁冶椰掖腋謁鄴靨曄鋣一以意已義議醫易衣藝依譯移異益亦億疑遺憶宜椅伊儀誼抑翼矣役艾乙溢毅蛇裔逸姨夷軼怡蟻弈倚翌頤疫繹彝咦佚奕熠貽漪詣迤弋懿囈驛咿揖旖屹痍薏噫鎰刈沂臆縊邑胰猗羿釔艤劓仡酏佾埸詒圯荑壹挹嶷飴嗌嶧懌悒銥欹殪黟苡肄鐿瘞癔翊蜴眙翳因音引印銀隱飲陰姻癮吟寅殷淫茵蔭尹蚓垠喑湮胤鄞氤霪圻銦狺吲夤堙齦洇茚窨應英影營迎硬映贏盈穎鷹嬰蠅櫻瑩熒膺螢縈鶯罌瀛楹纓潁嬴鸚瑛塋嚶瓔滎攖郢癭鎣瀅瀠媵喲唷用永擁勇涌踊泳庸傭詠俑雍恿甬臃邕鏞癰壅鱅饔喁墉蛹慵有又由友遊右油優郵幽尤憂猶悠幼誘佑黝攸呦酉柚魷莠囿鼬鈾卣猷牖銪疣蚰蝣釉蝤繇莜侑蕕宥蚴尢於與語育餘遇獄雨於欲預予魚玉愈域譽籲宇寓豫愚輿粥鬱喻羽娛裕愉禹浴餘御逾漁渝俞萸瑜隅馭迂揄圄諭榆嶼淤毓虞禺諛嫗腴峪竽芋妤臾歟齬覦盂昱煜熨燠窬蝓嵛狳傴俁舁圉庾菀蕷飫閾鬻瘐窳雩瘀紆聿鈺鵒鷸蜮員元原院遠願園源圓怨緣援冤袁淵苑猿鴛轅垣媛沅櫞芫爰螈黿眢圜鳶箢塬垸掾瑗月樂越約閱躍曰悅嶽粵鑰刖瀹櫟樾龠鉞運雲允韻暈孕勻蘊醞筠芸耘隕紜殞慍氳狁熨鄆惲昀韞鄖"
    "雜扎砸咋咂匝拶在再載災仔宰哉栽崽甾咱贊暫攢簪糌瓚拶昝趲鏨藏髒葬贓臧鍺奘駔早造遭糟澡竈躁噪鑿棗皁燥蚤藻繰唣則責澤擇咋嘖仄迮笮簀舴幘賾昃賊怎譖增贈憎繒罾甑鋥炸扎咋詐乍眨渣札柵軋閘榨喳揸柞楂哳吒鍘砟齇吒痄蚱摘債宅窄齋寨翟砦瘵戰展站佔沾斬輾粘盞嶄瞻綻蘸湛詹氈棧譫搌旃長張章丈掌漲帳障賬脹仗杖彰璋蟑樟瘴漳嶂鄣獐仉幛嫜着找照招朝趙召罩兆昭肇沼詔釗啁棹笊這着者折哲浙遮轍輒謫蔗蟄褶鷓鍺磔摺蜇赭柘真陣鎮震針珍圳振診枕斟貞偵賑甄臻箴疹砧楨縝畛軫胗稹禎湞溱蓁椹榛朕鴆政正證整爭徵掙鄭症睜徵蒸怔箏拯錚崢猙諍鯖鉦幀之只知至制直治指支志職致值織紙止質執智置址枝秩植旨滯徵幟稚摯汁擲殖芝吱肢脂峙侄窒蜘趾炙痔咫芷櫛枳躑桎帙梔祉輊贄痣豸卮軹埴陟郅黹忮彘騭酯摭縶跖膣雉鷙胝蛭躓祗觶中種重衆終鍾忠衷腫仲鍾踵盅冢忪舯螽周州洲粥舟皺驟軸宙咒晝肘帚胄紂謅縐妯碡啁葤籀繇酎主住注助著逐諸朱駐珠祝豬築竹煮囑柱燭鑄株矚蛛佇拄貯洙誅褚銖箸蛀茱炷躅竺杼翥渚瀦麈櫧櫫苧侏瘃疰邾舳抓爪拽嘬傳專轉賺撰磚篆囀饌顓裝狀壯莊撞妝幢樁奘僮戇追墜綴錐贅隹椎惴騅縋準諄窀肫着桌捉卓琢灼酌拙濁濯茁啄斫鐲涿焯浞倬禚諑擢子自字資諮紫滋仔姿吱茲孜梓漬籽姊恣滓諮齜秭呲輜錙眥笫髭淄茈觜訾緇耔鯔嵫貲孳粢趑總宗縱蹤綜棕糉鬃傯腙樅走奏鄒揍騶鯫諏陬鄹組足族祖租阻卒詛俎鏃菹賺鑽攥纂躦纘最罪嘴醉咀觜蕞尊遵樽鱒撙作做坐座左昨琢佐鑿撮柞嘬怍胙唑笮阼祚酢")
  "ASCII char to traditional Chinese characters.  Powered by OpenCC.
Thanks to BYVoid.")

(defconst pinyinlib--wubi-simplified-char-table
  '("艾蔼鞍芭靶茇菝蒡薄苞葆蓓鞴萆苯蔽萆薜蓖荸芘荜鞭苄匾薄菠菜蔡藏苍草茶茬蒇菖苌臣茌茺莼茨茈葱苁蔟萃鞑靼甙萏荡菪蒂荻东董鸫蔸芏苊萼莪蒽贰范藩蕃蘩芳菲匪芾芬葑芙芾苻茯莩菔苷藁革戈葛茛工共功攻贡恭巩汞苟觏鞲遘菇菰莞鹳匦菡巷蒿薅荷菏蘅薨蕻荭葫花划萑黄荒荟茴蕙荤或获惑劐藿藉蓟荠蒺芨蕺芰茄荚葭荐茧菅鞯蒹蒋匠茳蕉艽茭节戒藉芥靳觐堇荩警敬荆茎菁巨菊鞠苴鞫苣莒蕨菌蒈莰苛恐蔻芤苦蒯匡葵匮蒉莱蓝莨蒗劳勒蕾莉莅藜荔苈藓蓠莲蔹莨蓼蔺菱苓茏蒌芦蓼落萝荦荬蔓颟鞔茫芒莽茅茂茆莓蒙萌瞢甍蘼苗藐鹋蔑苠茗莫蓦蘑茉摹幕慕墓募暮苜艿萘匿慝廿蔫茑孽蘖苎欧殴鸥瓯藕葩蒎蓬匹芘莩苤萍苹叵葡蒲菩莆七萋芪荠芑萁蕲葺葜芊荨芡蔷巧翘鞘荞鞒切茄勤芹芩擎苘檠茕邛蛩跫銎区蕖蘧苣颧荃鹊苒荛惹葚荏荣蓉戎茸鞣茹薷蓐芮蕤蕊若萨散莎芟苫苕鞘芍莘葚世式蓍莳贳薯蔬戍菽蒴菘薮苏蔌蒜荽荪蓑苔薹萄忒慝忒藤荑苕萜莛葶茼荼菟忒莞芄菀蔚萎苇薇葳蓊蕹卧莴巫芜芴昔熙茜觋菥葸蓰匣莶藓苋项巷葙芗萧鞋邪薤薪芯荇荥芎蓄蓿萱靴薛荤荀薰蕈雅牙鸦芽迓燕芫郾菸鞅药尧医艺艾颐弋薏荑苡翳茵荫鄞茚英营莹荧萤萦莺茔荥蓥莠莜莸萸芋菀蓣苑芫鸢蕴芸匝藏葬臧藻赜蘸蔗蓁蒸芝芷荮著茱苎茁茈菹蕞"
    "阿隘阪孢陂陛陈承丞耻蚩出除陲聪耽聃阽耵陡队堕耳防附尕陔戤隔耿孤聒孩函隍隳及际亟降阶孑卺阱聚孓孔聩隗了联了聊辽陵聆陆隆陇陋陆孟勐陌乃鼐聂陧颞聍陪皮陂陴聘颇陂亟阡取娶孺阮陕随祟隧隋孙陶粜陀卫隈隗阢隙隰险限陷降陉逊阽阳也耶隐阴盈隅院孕陨障阵职陟骘坠子孜陬鄹阻阼"
    "巴畚弁骠驳参骖参叉骣骋驰骢皴怠迨骀邓叠犊对怼驮驸颈牿牯观骇骅欢鸡骥犄艰犍骄劲矜颈迳刭驹犋骏犒骒垒骊骝驴骆骡马矛牦蟊蝥瞀鍪牧牟牡难能骗犏骈骠牝骑骐犍巯驱劝逡柔叁毵桑颡骚骟参圣牲驶双驷厶台邰骀炱特通驼驮物鹜骛牾婺戏牺骧骁熊驯验以矣驿勇恿甬又预予豫驭鹬允驵蚤骤驻骓驺"
    "碍砹鹌百帮邦磅碑碚奔夯甭泵砭碥飙髟鬓礴布礤厕碴厂砗辰碜成盛舂础厨春唇蠢磁蹙存磋厝大达耷砀磴砥碲碘碉碟碇硐碓礅砘夺厄而鸸砝矾奋丰奉砜否砩尬感尴矸硌龚故古顾辜鸪嘏硅磙还夯厚胡鹕瓠砉还鬟磺灰慧彗基奇矶髻剞戛嘏恝碱硷礓礁碣兢厩鬏厥劂砍勘戡克磕刳夸矿夼盔奎髡砬磊历励厉厘砺砾奁鹩尥鬣磷碌硫龙聋垄砻碌硌码硭髦礞面奈耐孬硇碾恧磅匏碰砰硼否丕砒邳破其期奇欺戚契砌欹綦碛牵鬈硗砌挈秦戌磲犬鬈确髯辱三磉厦砂髟奢厍甚蜃砷盛石寿耍爽硕斯肆厮碎太态泰碳套焘髫厅砼砣歪碗尢威硪戊袭矽硒夏厦硖咸厢硝硎雄髹戌砉碹压砑研厌雁艳奄砚赝餍魇厣页靥欹硬友右尤尢郁原愿砸在仄砟丈磔斟砧碡砖斫髭鬃奏左"
    "腌爱胺肮办膀胞豹边膘膑脖膊采彩豺肠塍膪腠爨脆毳脞胆貂腚胨胴肚腭肪肥肺腓鼢服腹肤脯孚腑郛肝肛胳膈哿肱股臌胍盥胱虢胲貉贺貉毁肌加架驾迦胛袈毽腱脚胶胫腈肼舅臼雎脚爵胩胯脍腊肋肋力脸臁膦胧胪氇脶脉毛貌朦觅脒腼邈膜貉貊貘毪肭腩脑腻脲脓胖膀脬胚朋鹏膨脾貔胼脯氆脐肷腔且朐肜乳朊脎腮臊膳膻胂胜受鼠腧甩舜叟胎肽毯膛腾滕腆腿豚脱妥腽腕脘璺肟鼯膝奚鼷舄县腺胁勰腥胸貅须悬腌胭鼹遥腰鹞舀繇腋臆胰媵用臃有鼬繇舆腴臾舁爰月刖脏毡胀胗朕肢脂豸膣胝肿肘繇助肫腙胙"
    "埃霭埯坳霸坝耙坂雹孛埤贲甏贲埤博勃孛鹁埔埠才裁场超朝耖坼趁城埕赤翅坻墀矗寸戴埭地堤坻觌颠坫耋堞垤动垌都都堵堆墩垛二坊霏坟封赴垓干赶甘坩塥圪耕埂垢彀鼓毂瞽卦圭过埚韩翰顸邗邯耗郝壕赫盍堠壶觳坏卉恚魂霍耠吉圾霁戟赍嘉耩教截劫颉进境井赳趄均垲刊堪坎考壳坷坑堀垮块款圹亏逵坤垃老耢雷耒塄雳嫠坜墚趔埒霖零酃垅耧露垆卖埋霾墁耄霉耱某坶南赧垴霓坭埝耨耦耙耪培霈彭堋坯霹鼙圮埤坪坡埔起耆亓圻乾墙趄罄磬謦去趣趋却悫壤韧颥霰丧埽啬霎埏墒垧赦声十士示埘螫霜寺耜索塔塌坦坛坍趟塘耥韬填霆垌土堍坨顽未违韦圩雯斡无雾坞圬喜熹霞献霰孝霄协颉馨幸需墟圩雪埙垭盐堰懿埸圯壹垠霪圻堙墉雨域雩元远袁垣鼋塬垸越运云耘韫载哉栽趱增朝赵者赭真震圳直支志址埴煮翥专耔趑走"
    "玥瑷熬敖骜鳌遨獒聱螯鏊班斑逼碧表殡玢丙邴玻残蚕璨曹虿琛豉亍琮璁殂璀带歹殆玳殚到纛玷靛玎豆逗毒蠹顿趸恶噩垩珥珐玢夫副麸丐鬲亘更珙规瑰珩翮珩互瑚琥画环璜惠珲虺珲击殛丌玑夹颊珈郏歼戬戋豇晋瑾静靓救玖琚珏开珂琨来赉琅理丽璃吏郦逦鹂鬲殓琏两靓列烈裂琳玲琉珑璐珞玛麦迈劢瑁玫灭珉玟末殁囊瑙辇弄琶琵殍平珀璞妻琪琦琴青琼求球裘逑璩融瑞卅瑟珊殇事豕殊死素琐瑭忑替天忝殄餮吞屯橐瓦万玩豌琬王玮五武恶吾兀鹉下瑕现燹形型刑邢顼璇殉亚琊严焉琰鄢殃瑶珧一夷殪瑛璎于与玉瑜迂欤盂瑗殒再瓒遭责盏璋珍臻政正至致殖郅逐珠赘琢琢"
    "凹龅悲辈彪卜步卜睬餐粲柴觇龀瞠齿眵瞅龊此雌鹾眈瞪睇点盯鼎督睹盹非斐翡蜚壑虎乩睑睫睛旧韭具瞿遽龃矍卡瞰瞌肯龈眍眶睽睐瞵龄卢颅卤虏鸬虑瞒眯芈眠眄瞄眇瞑眸目睦睨虐盼裴睥瞟频颦攴歧虔瞧觑瞿龋氍睿上叔丨睡瞬兕瞍睢眭睃忐眺龆瞳凸凹龌瞎些虚盱眩睚眼眙龈卣虞龉眨砦战占瞻贞睁止瞩桌卓紫龇眦觜訾赀觜"
    "澳灞浜弊敝濞滗汴憋蹩鳖滨濒波泊渤不沧漕测涔汊潺澶常尝敞氅潮澈沉尘澄池滁淳淙淬沓淡澹当党凼滴涤淀滇洞渡渎沌沲洱法泛沸淝汾瀵沣浮涪滏尜溉泔澉淦港沟沽汩灌涫光滚海汉汗涵瀚沆浩灏濠河涸洪鸿泓黉鲎湖沪浒滹滑淮涣浣洹漶潢湟汇辉洄浍混浑溷活济激脊汲洎浃湫渐尖溅涧湔江洚觉浇湫洁津浸泾酒举沮涓觉浚渴溘喾浍溃涞濑滥澜漤浪潦涝泐泪漓沥溧澧涟濂潋梁粱潦劣洌淋泠流溜浏鎏泷漏泸漉潞渌滤滦沦洛泺漯满漫漭泖没湄浼懑泌汨湎沔渑渺淼泯溟漠沫沐淖泥溺涅泞浓沤派湃潘泮滂泡沛湓澎淠漂瞥婆泊泼泺浦瀑溥濮汽泣漆沏淇汔柒洽浅潜沁溱清泅湫渠雀染溶汝濡洳溽润洒挲涩沙挲鲨裟汕潸尚赏裳少潲涉滠深沈渗渖省渑湿淑漱澍沭涮泷水汜泗澌淞溲溯涑濉挲娑沓漯溻汰滩潭澹堂汤烫淌棠溏涛淘滔洮涕添汀潼涂湍沱洼湾汪渭潍洧沩涠温汶渥沃涡污浯鋈洗溪淅汐浠涎湘小消潇肖削逍淆泄泻瀣渫兴汹溴浒洫溆渲漩泫学削泶洵汛浔浚涯演沿淹湮滟洋漾泱耀液溢漪沂淫湮洇瀛滢潆涌泳游油誉浴渔渝淤源渊沅瀹澡泽渣沾湛掌涨漳沼浙浈溱治滞汁洲注洙渚潴浊濯涿浞滋渍滓淄"
    "暧暗昂蚌暴曝蚌蝙晡螬蝉蟾昌畅晁晨蛏匙螭虫蜍蝽旦戥电蝶蚪遏蛾蜂蜉蚨蝠蝮旰杲虼蚣蛊蛄归晷炅果蝈蜾蛤旱晗蚶昊蚝颢曷蚵虹蝴晃蝗蟥晦晖蛔蟪夥蠖虮蛱坚监鉴蛟蚧紧景晶炅颗蝌蚵旷暌蝰昆蛞蜡旯览螂里蜊蛎蠊量晾临蛉蝼螺蚂蟆曼螨蟒冒昴昧盟蠓蜢虻冕蠛明暝螟蛑蝻曩蛲昵暖蟠螃蟛蚍蜱螵蛴蜞蜣螓晴蜻蚯虬蝤蛐蛆蠼蜷蚺日蝾蠕蚋晒蟮晌蛸蛇申肾晟是时师匙暑竖墅曙帅蟀蛳螋遢昙螳螗题剔蜩蜓蜕暾蛙晚蜿旺韪蚊蜗晤蜈晰曦蟋蜥螅暇虾显贤暹蚬蟓晓蛸歇蝎昕星煦勖暄曛蚜蜒晏蛘曜野曳晔易蛇蚁蜴蚓影映蝇蛹蚰蝣蝤蚴遇愚禺昱蝓蜮螈曰晕昀早昃蚱蟑照昭蜘蛭蛛蛀最昨"
    "啊呵嗄吖唉哎嗳嗌嗷吧叭跋呗趵呗蹦嘣鄙哔吡跸别跛趵踣啵哺卟嚓踩嘈蹭噌喳嚓躔唱吵嘲嗔呈噌逞吃哧嗤叱踟踌躇蹰啜踹嘬川串喘吹啜踔呲蹴蹿啐蹉嗒哒呆呔啖蹈叨蹬噔嘀嗲踮吊叼跌喋踮蹀叮啶咚嘟吨蹲踱咄跺哆哚哦呃鄂颚鹗蹯啡吠吩唪咐趺跗呋咖嘎噶咯嗝跟哏哽咕呱剐咣贵跪呙哈嘿咳嗨喊号嚎嗥嚆喝吓呵嗬嘿嗨哼哄喉吼呼唬唿哗踝患唤喙哕咴嚯叽跻唧咭哜戢跽跏践趼踺叫嚼跤噍嗟喈噤啾距咀踽踞鹃嚼嗟蹶噱噘咖喀咔呵咳嗑啃吭口叩哭跨哙哐喟喹跬啦喇啷唠叻嘞哩喱呖唳跞踉嘹咧躐躏啉另呤咙喽路噜鹭吕呒吗骂嘛唛咪嘧黾喵咩黾鸣嘿哞嗯唔呢哪呐喃囔呶呢嗯唔呢蹑嗫啮咛哝喏哦噢喔呕趴啪哌蹒跑咆呸喷嘭啤噼吡蹁嘌品噗蹼器蹊嘁遣呛跄跷噙嗪吣嚷喏蹂嚅噻嗓啥嗄唼跚哨呻哂史嗜嘘噬唰顺吮嘶嗣咝嗽嗾嗖嗉虽嗦唆唢嗍踏嗒蹋趿呔跆叹啕饕踢啼蹄嚏跳听嗵吐唾跎鼍哇味唯喂吻嗡喔吴呜唔吸嘻蹊唏吓唬呷跣跹响嚣啸哮哓躞兄嗅咻吁嘘喧噱勋呀哑咽唁咬吆叶咽噎遗咦呓咿噫邑嗌吟喑吲嘤郢哟唷踊咏喁呦吁喻员跃郧咋咂咱躁噪唣咋啧咋喳哳吒咤啁只吱趾踯跖踬中忠踵盅咒啁嘱躅嘬啭啄吱呲踪足躜嘴咀嘬唑"
    "黯罢畀黪车畴黜辍辏町黩囤轭恩罚畈辅辐罘轧罡固轱罟轨辊国黑轰囫轷圜回辑畸羁墼甲囝较轿界轲困罱累罹詈轹连辆辚囹辘轳辂略轮囵罗逻皿默墨男囡囝嬲畔辔毗罴圃畦堑黔椠轻圊黥囚黢圈辁畎轫软轼输署蜀四思田畋町图团疃囤畹辋围畏胃囗軎辖黠轩鸭轧罨轺轶黟因黝囿圄圉园圆辕圜暂錾罾轧斩辗罩辙辄畛轸置轾轵轴转辎罪"
    "岸盎岜败贝崩髀贬豳髌财册岑崇帱遄幢赐崔嵯丹赕帱嶝迪骶典巅雕岽峒赌髑峨贩帆幡峰酆幅赋幞赙赅刚岗冈骼屹购岣骨鹘崮刿帼崞骸骺岵鹘幌贿岌觊嵴岬见贱峤骱巾赆迥崛峻凯剀髁岢崆骷髋贶岿崃岚崂嶙岭髅嵝赂幔帽峁嵋岷内帕赔帔岂崎岐屺髂嵌岍峭峤赇曲岖冉嵘肉山删赡赊嵊峙赎崧嵩岁髓炭贴帖同彤峒骰崴网罔巍帷帏崴嵬幄峡岘崤岫峋崖岈岩崦央鸯崾贻屹嶷峄婴罂鹦由邮幽屿峪嵛崽赃则帻贼赠崭帐账嶂幛赈峥帧帜峙帙周胄贮赚颛幢嵫赚"
    "懊悖鐾必避壁臂璧愎嬖襞忭檗擘怖惨惭孱恻层忏孱羼怅惝怊忱迟尺憧忡丑惆怵憷怆戳翠悴忖怛蛋惮导悼忉翟殿惦刁懂恫惰愕屙飞悱愤怫改敢怪惯憾悍憨恨恒惚怙怀慌惶恍悔恢己忌悸屐届尽惊憬局居剧惧屦慨恺忾慷尻恪快愧悝愦悃懒愣悝怜懔鹨戮履屡买慢忙眉鹛懵乜民悯愍那恼尼怩尿乜忸懦怄怕怦屁辟劈譬疋甓屏恰悭慊悄憔愀怯惬慊情屈悛慑慎尸屎恃虱收书属疏疋刷司巳悚忪愫惕屉悌恬恸恫屠臀惋惘慰尾惟尉屋悟毋忤怃习惜犀屣遐屑懈心忻性悻惺恤胥迅巽恂疋恹怏已异忆翼乙怡翌羿怿悒慵忧羽愉熨悦愠熨恽憎翟展怔咫忮忪昼惴怍"
    "粑爆焙煸炳灿糙廛鬯炒焯炽炊糍粗粹灯断煅炖烦燔粉粪烽腐黼黻糕炔焊焓烘糇糊烀煳焕煌烩火糨烬精粳炯炬爝炕糠烤烂烙类粒粝炼粮料燎麟遴粼熘娄炉烙熳煤焖米迷敉粘糯炮粕炝糗炔燃熔糅糁煽剡熵烧糁炻数烁燧郯糖烃煺烷为炜煨焐熄烯粞籼糈炫煊烟炎焰焱剡烊炀业烨邺熠煜燠糌糟灶凿燥炸粘黹烛炷灼焯籽粽凿"
    "安案袄宝褓被褙裨窆褊裱宾补察衩禅衬宸裎褫宠初褚穿窗祠窜褡裆宕祷定窦裰额福富袱祓割袼宫寡褂官冠宄害寒罕鹤褐宏祜宦寰逭祸豁寄寂家袷蹇謇裥窖襟衿窘究裾窭军皲客窠裉空寇裤窟宽窥褴牢礼帘裢裣寥寮窿禄褛裸寐袂密蜜宓祢幂冥寞衲祢宁甯农襻袢袍裨祈祺祁袷骞搴褰襁窍窃寝穷穹祛裙禳衽容冗褥襦赛塞塞衫社神审实视室守祀宋宿邃它袒裼窕祧突褪褪袜完宛剜窝寤禧穸禊宪祆祥宵写袖宿宣穴窨宴窑窈宜寅窨宥宇寓裕窬窳冤郓灾宰宅窄寨这褶祯鸩之窒祉祗冢宙祝褚窀禚字宗祖祚"
    "锕锿铵犴钯鲅钣镑包鲍饱刨狈钡锛铋狴鳊镖镳鳔镔饼饽铂钵钹钸钚猜镲锸猹馇钗馋铲镡猖鲳钞铛铖饬鸱铳触雏锄刍舛钏锤匆猝镩错锉铛岛锝镫狄邸氐镝甸钿钓铫铞鲷鲽钉铤锭铥独镀锻镦钝镦多铎饿鳄锷锇儿尔迩饵铒鲕饭犯钒钫鲂鲱狒镄鲼锋负匐孵凫鲋鳆钆钙钢镐锆镉铬鲠觥够狗勾钩锢钴觚鲴馆鳏逛犷龟鲑鳜鲧锅猓铪镐狠訇猴忽狐斛猢鹱猾铧奂锾郇獾鲩鳇昏馄锪钬镬急饥鲫鲚钾镓铗键锏饯鲣角饺狡鲛铰解桀鲒金锦馑镜鲸獍久灸句锯钜锔狙镌锩狷獗镢觖钧铠锎锴钪铐钶锞铿狯狂馈鲲锟铼镧狼锒铹铑鳓镭狸鲤鳢鲡猁锂链镰鲢镣钌獠猎鳞铃鲮留遛馏镏锍镂鲁鲈镥铝卵锊锣猡镙犸馒鳗镘猫贸卯锚铆猸镅镁钔猛锰猕免勉名铭馍镆钼钠镎馕猱铙馁鲵猊铌鲶鲇鸟袅镊镍狞钮狃钕锘钯刨狍锫铍鲆钷钋铺匍镨镤鳍钱欠铅钳钎钤锵锖镪锹锲钦锓卿鲭鳅犰鸲劬铨然饶饪狨铷锐鳃馓鳋色铯煞铩钐鳝觞勺猞氏饰狮蚀鲥铈鲺狩铄饲锶馊锼稣觫狻狲飧锁鳎铊獭鲐钛镡锬钽铴镗饧逃鼗铽锑逖钿鲦铁铤铜钭兔钍饨鸵铊外危猥猬鲔刎我勿钨夕锡玺铣饩狭狎鲜馅猃锨铣象镶饷销枭蟹邂獬鑫锌镡猩饧匈锈馐铉镟鳕旬郇獯鲟钥铫鳐铘逸镒猗钇饴铱镱印银饮铟狺夤迎镛鳙犹鱿铀铕狱鱼馀狳饫钰怨猿鸳眢钥钺匀狁锗锃铡詹獐兆钊锗镇针争铮狰鲭钲炙觯钟锺皱猪铸铢橥馔锥镯锱鲻邹鲰镞钻鳟"
    "挨皑捱按氨揞拗翱把拔扒魃捌白摆拜掰捭搬扮拌扳报抱卑鹎摈兵摒播拨搏掰帛捕擦掺操插刹搽拆搀掺抄撤扯抻撑持斥魑抽搐揣搋氚捶攒撺摧措搓挫撮打搭担掸氮挡捣氘的提抵垫掂掉瓞揲氡抖兜盾遁掇扼摁反返氛扶抚拂氟拊擀扛搞皋搁搿拱挂瓜拐掴掼鬼皈掴氦撼捍撖皓后逅护换擐皇遑挥攉技挤掎挟皎挢敫捡拣搛搅皎敫挢接捷揭拮近斤揪据拒拘掬捐掘抉攫撅捃揩看抗扛拷氪控扣抠挎魁揆捆括扩拉拦揽捞擂魉撩撂捩拎拢搂掳撸捋氯掠抡摞捋抹魅扪描抿摸抹拇捺氖攮挠拟捻撵拈捏拧扭拗挪搦爬扒排拍拚乓抛捧抨批披郫擗撇氕拼拚乒迫魄皤掊扑气颀掐掮扦抢撬郄擒揿氢氰邱丘泉攘扰热扔揉撒搡扫搔杀刹擅掺掸捎摄势拾逝誓拭弑手授抒摅摔拴搠撕搜擞损所挞抬探摊搪掏提掭挑挺捅投抟推托拖拓挖挽皖魍握挝捂希郗欷掀氙魈携挟撷欣擤凶揎踅押揠氩掩扬氧摇邀肴爻拽揶掖抑揖刈挹殷氤撄拥揄援掾岳氲扎拶攒拶皂择扎揸摘搌找招折哲蛰摺蜇振挣拯指质执挚掷贽卮摭絷鸷拄抓爪拽撰撞捉拙擢揍攥撙撮"
    "桉柏板棒榜梆杯本标杓彬槟柄柏逋醭材槽查杈楂槎檫郴榇橙枨酲柽敕酬楚橱杵楮樗椽槌棰醇椿刺枞楱醋酢榱村档棣柢顶丁酊栋杜椟椴柁梵樊枋榧焚棼酚枫覆甫敷桴概杆橄柑酐杠槁槔歌格哥根梗构枸梏酤栝棺桄桂柜桧棍椁醢酣杭核横桁醐槲桦槐桓桧机极棘楫贾枷检槛柬枧楗校椒酵醮杰禁槿柩桕桔橘椐枸榉醵鄄橛桷楷槛栲可柯棵酷枯框醌栝剌赖栏榄婪榔酪醪栳檑酹楞棱李栗枥栎醴楝椋林檩棱棂柃柳榴栊楼麓栌橹榈椤杩懋梅枚酶楣梦檬醚棉杪酩模木柰楠酿柠杷攀配醅棚枇票飘瓢剽榀枰朴棋栖杞槭桤枪樯桥樵橇覃檎楸麴权醛榷桡榕枘梢森酾杉栅梢杓椹柿酾术树述束梳枢栓松速酥粟酸榫梭桫榻酞覃檀樘醣桃梯醍梃桶桐酮酴椭酡柁柝枉桅梧杌西析樨皙檄醯柙酰想相橡校枵械榭楔榍醒杏朽栩酗醑楦醺桠檐酽样杨要杳椰椅酏樱楹酉柚榆橼栎樾酝枣札栅榨柞楂栈杖樟棹柘枕甄桢椹榛整枝植栉枳桎栀酯酎柱株杼槠桩椎酌梓棕枞醉樽柞酢"
    "矮奥岙笆稗版般舨备惫笨笔币鼻彼篦秕舭筚箅笾秉簸舶箔簿舱艚策长徜彻掣称程称乘惩秤笞篪彳重艟愁筹臭稠处船舡垂辞囱簇徂篡汆矬答笪待箪稻得德等簦第敌笛籴簟迭牒丢冬篼笃牍段短簖躲舵鹅乏筏翻番繁彷舫篚逢缶复符阜稃馥竿秆缸筻告稿睾篙郜各舸躬篝笱箍鹄刮鸹乖管罐簋鼾行航和禾很衡後篌乎鹄笏徊徨簧篁徽徊秽和积籍季稽笈稷嵇箕笄稼笳徼简箭舰笺笕矫徼街秸筋径咎矩榘筠靠科稞箜筘筷筐篑籁徕篮稂乐利黎笠梨篱犁黧篥笼篓簏舻律稆乱箩雒么每艋艨秘秒篾敏鳘秣穆年黏臬牛衄筢牌徘盘磐彷逄篷片篇丿笸鄱乞迄憩千签迁愆箝乔箧箐筇秋鼽躯衢筌缺穰壬稔入箬穑歃筛舢稍筲艄射舌身矧生升剩甥笙眚失释适矢舐筮艏黍秫税私笥艘簌算穗笋躺甜舔条笤廷艇筒透徒秃颓乇箨往委微魏逶艉稳务午舞乌邬迕系息稀悉徙舾罅先衔舷筅向香箱笑箫筱卸衅囟行秀臭徐选血循熏徇衙延衍筵鼽秧徉夭徭移役迤舣劓胤牖釉禹御毓竽箢乐粤筠赞簪昝造迮笮箦舴怎乍齄长笊箴稹征徵筝知制智秩徵稚雉种重舯螽舟籀朱筑竹箸竺邾舳篆追自秭笫租纂笮"
    "癌疤半瓣瘢癍北背邶迸闭痹辩辨辫瘭瘪并病冰部瓿曾差差瘥产阐冁阊痴瘛冲瘳闯疮次差慈瓷兹疵鹚凑瘁痤瘥瘩疸单瘅疸郸道盗弟递羝奠癫癜凋疔冻斗痘端兑阏阀痱疯冯盖赣疳戆羔阁疙羹痼关闺衮馘阚阂阖痕闳瘊冱痪豢癀阍疾冀瘠痂瘕间减兼剪煎翦鹣将奖酱姜浆桨交郊竭疖疥羯竟竞净靖痉疚阄疽卷眷桊蠲决竣阚闶疴况夔阃阔辣瘌癞兰阑阆痨冷立痢疠疬凉疗冽凛凌羚六瘤癃瘘闾瘰美门闷闽闵瘼闹逆凝疟判叛爿疱疲痞癖瓶剖普凄前歉羌戕羟妾亲酋遒癯阒券拳痊瘸阕阙闰飒瘙痧善闪鄯疝韶首瘦兽闩朔槊送凇竦塑遂羧闼瘫痰羰疼誊剃鹈阗痛童头痿闱问闻瘟阌痦羲阋瘕闲羡鹇痫冼翔鲞效新辛歆羞券痃癣丫痖颜阎阉彦闫阏兖养羊痒恙疡冶意益毅疫痍瘗癔翊音瘾瘿痈猷疣阈瘐瘀阅韵奘甑闸痄瘵站章彰瘴鄣着着疹郑症痔痣瘃疰装状壮妆奘戆准着资咨姿兹恣孳粢总尊遵"
    "嫒媪婢妣婊剥姹婵娼嫦巢媸巛妲逮刀嫡娣妒娥婀发妨妃妇旮艮媾姑妫好婚即既姬嫉妓暨嫁建奸娇姣剿姐婕妗婧九鸠娟君郡恳垦馗邋姥嫘隶娌灵录逯妈嬷妹媒媚娩妙嫫姆娜奶嫩妮娘妞怒努奴弩驽胬孥女媲嫖姘嫔娉嫱群娆忍刃妊如嫂姗嬗邵劭婶娠始恕姝孀妁姒肃她帑迢婷退娃娲婉丸娓妩媳嬉嫌娴姓絮旭婿寻巡娅妍嫣姚妖姨姻尹邕娱妪妤聿媛杂甾嫜召帚妯姊"
    "俺傲八爸伯佰伴颁傍保堡煲倍坌俾便飚飑傧伯仓伧侧岔侪偿倡倘伥伧侈傺仇雠俦储传创从丛促催隹代袋贷黛岱傣但儋倒登凳低佃爹佚仃侗朵剁俄佴伐垡凡仿分份忿偾风凤俸佛父付佛伏傅俯斧俘釜伽个鸽颌仡公供佝谷估倌刽傀癸含颔何合盒颌候侯华化凰会货伙几集祭伎偈佶价假佳佼侥伽件健剑俭僭牮僵焦佼侥僬鹪介借偈今仅儆僦俱飓倨倦隽倔俊隽佧侃龛伉倥侉会侩郐傀佬仂儡例俐俚俪傈俩敛俩僚邻赁领令伶翎瓴偻侣伦仑倮们命侔仫拿佴恁你倪伲念您恁佞侬傩偶俳佩盆僻仳便偏贫凭俜仆企俟伽倩佥仟戗侨俏劁伽侵禽衾倾俅全人任仁仞仍儒偌仨伞僧傻伤舍佘畲歙什伸使食侍仕售舒俞倏毹殳似伺俟耸颂怂飕俗夙僳隼他贪倘傥体倜佻停佟侗仝偷途氽佗佤位伟伪偎翁瓮倭伍侮仵兮翕僖歙侠仙像斜偕信修休鸺叙儇伢俨偃仰佯侥爷依亿伊仪倚佚仡佾佣俑优悠佑攸侑余欲愈逾俞觎伛俣鹆龠仔债仗仉侦值侄众仲住伫侏传僮隹倬仔偬俎作做坐佐"
    "绊绑鸨绷比毕毙匕弼毖编缏缤缠绰弛绸绌纯绰绐弹缔绨缎缍纺费绯纷缝弗缚艴绂绋绀纲缟纥给绠弓缑贯纶绲绗纥红弘弧缓幻缳绘缋给级纪继绩缉畿缄缣强疆犟缰绛缴绞结皆缙经弪纠绢绝缂绔纩缆缧蠡缡练缭绫绺绿缕纶络缦弥弭糸缅绵缪缈缗缪缪母纳纽纰缏缥绮纤缱缲顷绻强绕纫绒缛弱缲缫纱缮绱绍绅绳绶纾丝鸶缌绥缩弹绦缇绨统彖纨绾维纬纹细线弦纤乡飨缃绡缬绁绣续绪绚幺疑绎彝缢肄引颖缨颍幼粥鬻纡缘约纭缲缯绽张缜织纸旨彘终粥纣绉缀缒缁纵综组缵"
    "庇庳庵鏖廒床底店度废府庚赓广庋麾麂廑麇康库邝廓廊廉廖廪鹿庐麻麽糜靡糜麋縻庙麽磨摩魔庞庖庀麒廑庆麇麝庶唐庭庹庑席庠廨庥序应鹰膺庸庾遮鹧麈庄座哀谙谤褒变遍扁卞斌禀亳诧颤谄谗昶谶谌诚啻充畜鹑词卒诞谠帝诋谛丶调谍订读憝敦讹谔诶方放房访邡诽扉讽讣该高膏诰诟雇诂诖诡郭裹亥颃毫豪诃劾亨讧户戽扈话谎肓讳诲诙诨记计迹剂讥诘齑肩谏谫讲诫诘讦谨京旌扃就鹫讵诀谲亢刻课颏诓诳斓谰朗郎羸诔离戾恋良亮谅吝刘旒旅率膂峦挛孪栾銮娈鸾脔论蠃蛮谩盲氓邙袤旄谜谧谬谟谋亩讷旎诺讴旁旆烹翩扁谝评裒谱齐旗弃启讫綮谦谴敲诮谯请綮诎诠让瓤认扇讪商设谁诜谂市识诗试施谥熟孰塾率衰谁说诵讼诉谡谇谈谭讨调亭弯望忘亡妄谓诿文紊於误诬享详襄谢谐亵燮许畜诩旋玄谖谑询训讯讶言谚谳谣夜谒义议衣译亦谊裔弈奕诣旖诒赢嬴永雍壅饔诱语育於谕谀谮诈斋谵旃肇诏谪诊证诤衷州诌主诸诛谆诼谘诹族卒诅"
    "")
  "ASCII char to simplifed Chinese characters with wubi char table.")

(defconst pinyinlib--wubi-traditional-char-table
  '("艾藹鞍芭靶茇菝蒡薄苞葆蓓鞴萆苯蔽萆薜蓖荸芘蓽鞭苄匾薄菠菜蔡蠶藏蒼草茶茬蠆蕆菖萇臣茌茺蓴茲茨茈蔥蓯蔟萃韃靼帶甙萏蕩菪蒂荻董蔸芏躉苊萼莪蒽貳藩蕃蘩芳菲匪芾芬葑芙芾苻茯莩菔蓋苷藁革戈葛茛工共功攻貢恭鞏汞苟覯遘菇菰觀莞鸛匭菡巷蒿薅荷菏蘅薨蕻葒葫華花歡萑黃荒匯薈茴蕙葷或惑劐藿藉薊薺蒺芨蕺芰茄莢葭堅監艱薦繭菅韉蒹戔蔣匠茳蕉艽茭戒藉芥緊靳覲堇藎警驚敬荊莖菁舊巨菊鞠苴鞫苣莒蕨菌蒈莰苛恐蔻芤苦蒯匡葵匱蕢萊蘭藍覽莨蒗勒蕾莉蒞藜荔藶蘚蘺蓮蘞莨蓼臨藺菱苓蘢蔞蘆蓼落蘿邁勱蕒蔓顢鞔茫芒莽茅茂茆莓夢蒙萌瞢甍蘼苗藐鶓蔑苠茗莫驀蘑茉摹幕慕墓募暮苜艿萘難匿慝廿蔫蔦孽苧歐毆鷗甌藕葩蒎蓬匹芘莩苤萍蘋叵葡蒲菩莆七萋芪薺芑萁蘄葺葜芊蕁芡薔巧鞘蕎鞽切茄勤芹芩擎檠邛蛩跫銎區蕖蘧苣勸顴荃鵲苒蕘惹葚荏蓉戎茸鞣茹薷蓐芮蕤蕊若薩散莎芟苫鞝苕鞘芍腎莘葚世式蓍蒔貰薯豎蔬戍菽蒴菘藪蘇蔌蒜荽蓀蓑苔薹萄鞀忒慝忒藤荑苕萜莛葶茼荼菟忒萬莞芄菀蔚萎葦薇葳蓊蕹臥萵巫蕪芴昔熙茜覡菥葸蓰匣賢薟蘚莧項巷葙薌蕭鞋邪薤薪芯荇芎蓄蓿萱靴薛薰葷荀薰蕈雅牙鴉芽迓燕鹽芫郾菸鞅藥葉醫藝艾頤弋薏荑苡翳茵蔭鄞茚英莠莜蕕萸芋菀蕷苑芫鳶蘊芸匝藏葬臧藻賾盞蘸蔗蓁蒸芝芷葤著茱苧莊茁茲茈菹蕞"
    "阿隘阪阪孢陂陛陳承丞恥蚩出除陲聰耽聃阽耵陡隊墮耳防附尕陔戤隔耿孤聒孩函隍隳及際亟降階孑巹阱聚孓孔聵隗了聯了聊陵聆陸隆隴陋陸孟勐陌乃鼐聶隉顳櫱聹皰陪皮陂陴聘頗陂亟阡取娶孺阮陝聖隨祟隧隋孫陶糶聽陀隈隗阢隙隰險限陷降陘遜阽陽也耶隱陰盈隅院孕隕障陣職陟騭墜子孜陬鄹阻阼"
    "巴畚弁驃駁參驂參叉驏騁馳驄皴怠迨駘犢馱駙牿牯駭驊驥犄犍驕矜駒犋駿犒騍驪騮驢駱騾馬矛蟊蝥瞀鍪牧牟牡能騙犏駢驃牝騎騏犍驅逡柔叄毿桑顙騷騸參牲駛駟厶態邰駘炱特通駝馱物務鶩騖牾婺犧驤驍熊馴驗以矣驛勇恿甬又預予豫馭鷸允駔蚤驟駐騅騶"
    "礙砹鵪百邦磅碑碚奔夯甭泵砭碥飆髟鬢礴布礤碴長硨辰磣成盛舂礎春脣蠢磁蹙存磋厝大耷碭磴砥碲碘碉碟碇硐碓礅砘奪厄而鴯砝奮奉碸否砩尬感尷矸硌故古辜鴣嘏硅磙夯厚胡鶘瓠砉鬟磺灰慧彗基奇磯髻剞夾頰戛嘏郟恝礓礁碣兢鬏厥劂砍勘戡克磕刳礦夼盔奎髡砬磊歷勵厲礪礫奩遼鷯尥鬣磷碌硫碌硌碼硭髦礞面靦奈耐孬硇碾齧恧磅匏碰砰硼否丕砒邳破其期奇欺戚契砌欹綦磧鬈磽砌挈秦戌磲犬鬈確髯辱三磉砂髟奢厙甚蜃砷盛石耍爽碩斯肆鬆碎太泰碳套髫砼砣歪碗尢威硪戊矽硒夏硤硝硎雄髹戌砉碹壓砑研厭雁奄硯贗饜魘厴頁靨欹硬友右尤憂尢原願砸在仄砟長丈磔斟砧碡磚斫髭鬃奏左"
    "愛胺膀胞豹膘臏脖膊彩豺腸塍膪辭腠爨脆毳脞膽貂腚腖胴肚兒肪肥肺腓鼢服腹脯孚腑郛肝肛胳膈哿肱股臌胍盥胱虢胲貉賀貉黌鱟毀雞肌加架駕迦胛袈毽腱覺腳膠脛腈肼舅臼舉雎覺腳爵胩懇墾嚳胯膾臘肋肋力臉臁膦朧臚氌亂腡脈毛貓貌朦覓脒邈膜貉貊貘毪肭腩腦膩脲膿胖膀脬胚朋鵬膨脾貔胼脯氆臍肷腔且朐肜乳朊脎腮臊膳胂勝受鼠腧甩舜叟胎肽毯膛騰謄滕腆腿豚脫妥膃腕脘爲璺肟鼯膝奚鼷舄腺脅勰釁興腥胸貅須學澩胭鼴腰鷂舀繇腋臆胰媵用臃有鼬繇與譽輿腴臾歟舁爰月刖脹胗朕爭肢脂豸膣胝腫肘繇助肫腙胙"
    "埃靄垵坳霸壩耙幫報雹孛埤賁甏賁埤博勃孛鵓埔埠才裁場超朝耖坼趁城埕赤翅坻墀矗寸達戴埭地堤坻覿電顛墊坫耋堞垤垌都都堵堆墩垛二坊霏墳封赴垓幹趕甘坩塥圪耕埂垢彀鼓轂瞽卦圭堝韓翰頇邗邯耗郝壕赫盍堠壺觳壞卉恚魂霍耠吉圾霽戟嘉耩教截劫頡境井赳趄均塏刊堪坎考殼坷坑堀垮塊款壙逵坤垃老耮雷耒塄釐靂嫠壢墚趔埒霖靈零酃壠耬露壚賣埋霾墁耄氂耱某坶南赧堖霓坭埝耨耦耙耪培霈彭堋坯霹鼙圮埤坪坡埔起耆亓圻乾翹趄罄磬謦去趣趨愨壤熱顬霰喪埽嗇霎埏墒垧赦聲十士示勢塒螫壽霜寺耜索塔塌臺坦壇坍趟塘耥燾填霆垌土堍坨頑未圩雯斡霧塢圬喜熹霞霰孝霄協頡馨幸需墟圩雪塤埡堰堯懿埸圯壹垠霪圻堙墉雨域雩元遠袁垣黿塬垸越雲耘載哉栽趲增朝趙者蟄赭真震圳直支志執址摯贄埴縶鷙煮翥耔趑走"
    "玥璦熬敖驁鰲遨獒聱螯鏊班斑逼碧表殯玢丙邴玻殘璨曹琛豉亍琮璁殂璀歹殆玳殫到纛玷靛玎丟豆逗毒蠹頓惡噩堊爾邇珥琺玢夫副丐鬲亙更頸珙規瑰珩翮珩互瑚琥環璜惠琿虺琿殛丌璣珈殲戩豇勁晉瑾靜頸逕剄靚救玖琚珏珂琨琅理麗璃吏酈邐鸝鬲殮璉兩靚列烈裂琳玲琉瓏璐珞瑪瑁玫珉玟末歿囊瑙輦弄琶琵殍平珀璞妻琪琦琴青瓊求球裘逑巰璩融瑞卅瑟珊殤事豕殊死素瑣瑭忑替天忝殄餮頭吞屯橐瓦玩豌琬王瑋五武惡吾兀鵡璽下瑕現燹形型刑邢頊璇殉亞琊焉琰鄢殃瑤珧一夷殪瑛瓔玉瑜迂盂瑗殞再瓚遭責璋珍臻政正至致殖郅逐珠豬櫫專贅琢琢"
    "凹齙悲輩彪卜步卜睬餐粲柴覘齔瞠齒眵瞅處齪此雌鹺眈瞪睇盯鼎鬥督睹盹齶非斐翡蜚膚劌壑虎乩見鹼鹼瞼睫睛韭鬮具劇瞿遽齟矍卡瞰瞌肯齦瞘眶虧睽睞瞵齡盧顱虜鸕慮瞞眯羋眠眄瞄眇瞑眸目睦鬧睨虐盼裴睥瞟頻顰攴歧虔瞧覷瞿齲氍睿上叔丨睡瞬兕瞍歲睢眭睃忐眺齠瞳凸凹齷戲鬩瞎縣獻鹹些虛盱懸眩睚眼眙齦卣虞齬眨砦瞻貞睜止矚桌卓紫齜眥觜訾貲觜"
    "澳灞浜幣弊斃敝濞潷汴憋蹩鱉濱瀕波泊渤不滄漕測涔汊潺澶常嘗敞氅潮澈沉澄池滁淳淙湊淬沓淡澹當黨凼盜滴滌澱滇洞渡瀆沌沲洱法泛沸淝汾瀵灃浮涪滏尜溉泔澉淦港溝沽汩灌涫光滾海漢汗涵瀚沆浩灝濠河涸洪鴻泓湖滬滸滹滑淮渙浣洹漶潢湟輝洄澮混渾溷活濟激脊汲洎浹湫減漸尖濺澗湔江洚澆湫潔津浸淨涇酒沮涓決浚渴溘澮況潰淶瀨濫瀾灠浪潦澇泐淚漓瀝溧澧漣濂瀲涼粱潦劣洌淋泠流溜瀏鎏瀧漏滷瀘漉潞淥濾灤淪洛濼漯滿漫漭泖沒湄浼懣泌汨湎沔澠渺淼滅泯溟漠沫沐淖泥溺涅濘濃漚派湃潘泮滂泡沛湓澎淠漂瞥婆泊潑濼浦瀑溥濮汽泣漆沏淇汔柒洽淺潛沁溱清泅湫渠雀染溶汝濡洳溽潤灑挲澀沙挲鯊裟汕潸尚賞裳少潲涉灄深沈滲瀋省澠溼淑漱澍沭涮瀧水汜泗澌淞溲溯涑濉挲娑沓漯溻汰灘潭澹堂湯燙淌棠溏濤淘滔洮涕添汀潼塗湍沱灣汪渭濰洧潙潿溫汶渥沃渦污浯鋈洗溪淅汐浠涎湘小消瀟肖削逍淆泄瀉瀣渫洶溴滸洫漵渲漩泫削洵汛潯浚涯演沿淹湮灩洋漾泱耀液溢漪沂淫湮洇瀛瀅瀠涌泳油浴漁渝淤源淵沅瀹澡澤渣沾湛掌漲漳沼浙湞溱治滯汁洲注洙渚瀦準濁濯涿浞滋漬滓淄"
    "曖暗昂蚌暴曝蚌畢蝙晡螬蟬蟾昌暢晁晨蟶匙螭蟲蜍蝽旦戥蝶蚪遏蛾蜂蜉蚨蝠蝮旰杲虼蚣蠱蛄晷炅果蟈蜾蛤旱晗蚶昊蠔顥曷蚵虹蝴晃蝗蟥晦暉蛔蟪夥夥蠖蟣蛺蛟蚧景晶炅顆蝌蚵曠暌蝰昆蛞蠟旯螂蜊蠣蠊量晾蛉螻螺螞蟆曼蟎蟒冒昴昧盟蠓蜢虻冕蠛明暝螟蛑蝻曩蟯昵暖蟠螃蟛蚍蜱螵蠐蜞蜣螓晴蜻蚯虯蝤蛐蛆蠼蜷蚺日蠑蠕蚋曬蟮晌蛸蛇申晟是時匙暑墅曙蟀螄螋遢曇螳螗題剔蜩蜓蛻暾蛙晚蜿旺蝟韙蚊蝸晤蜈晰曦蟋蜥螅暇蝦顯暹蜆蟓曉蛸歇蠍昕星煦勖暄曛蚜蜒晏蛘曜野曳曄易蛇蟻蜴蚓影映蠅蛹蚰蝣蝤蚴遇愚禺昱蝓蜮螈曰暈昀早昃蚱蟑照昭蜘蛭蛛蛀最昨"
    "啊呵嗄吖唉哎噯嗌嗷吧叭跋唄趵唄蹦嘣鄙嗶吡蹕別跛趵踣啵哺卟嚓踩嘈蹭噌喳嚓囅躔唱吵嘲嗔呈噌逞吃哧嗤叱踟躊躇躕啜踹嘬川串喘吹啜踔呲蹴躥啐蹉嗒噠呆呔單啖鄲蹈叨蹬噔嘀嗲踮吊叼跌喋踮蹀叮啶咚嘟噸蹲踱咄跺哆哚哦呃鄂顎鶚蹯啡吠吩唪咐趺跗呋咖嘎噶咯嗝跟哏哽咕呱咣貴跪哈嘿咳嗨喊號嚎嗥嚆喝嚇呵嗬嘿嗨哼哄喉吼呼唬唿踝患喚喙噦咴嚯跡嘰躋唧咭嚌戢跽跏踐趼踺叫嚼跤噍嗟喈噤啾距咀踽踞鵑嚼嗟蹶噱噘咖喀咔呵咳嗑啃吭口叩哭跨噲哐喟喹跬啦喇啷嘮叻嘞哩喱嚦唳躒踉嘹咧躐躪啉另呤嚨嘍路嚕鷺呂嘸嗎嘛嘜咪嘧喵咩鳴嘿哞嗯唔呢哪吶喃囔呶呢嗯唔呢躡囁嚀噥喏哦噢喔嘔趴啪哌蹣跑咆呸噴嘭啤噼吡蹁嘌品噗蹼器蹊嘁遣嗆蹌蹺噙嗪唚嚷喏蹂嚅噻嗓啥嗄唼跚哨呻哂史嗜噓噬獸唰順吮嘶嗣噝嗽嗾嗖嗉雖嗦唆嗩嗍踏嗒蹋趿呔跆嘆啕饕踢啼蹄嚏跳嗵吐唾跎鼉哇味唯喂吻嗡喔吳嗚唔吸嘻蹊唏嚇唬呷跣躚囂嘯哮嘵躞兄嗅咻噓喧噱呀啞嚴咽唁咬吆咽噎遺咦囈咿噫邑嗌吟喑吲嚶郢喲唷踊喁呦喻員躍鄖咋咂咱躁噪唣咋嘖咋喳哳吒吒戰啁只吱趾躑跖躓中忠踵盅咒啁囑躅嘬囀啄吱呲蹤足躦嘴咀嘬唑"
    "黯罷畀黲車疇黜輟輳點疊町黷囤軛恩罰畈輔輻罘軋罡固軲罟軌輥國還黑轟囫軤還圜回輯擊畸羈墼甲囝較轎界軻困罱累壘罹詈轢連輛轔囹婁轆轤輅略輪圇羅邏罵買皿默墨男囡囝嬲畔毗羆圃畦塹黔槧輕圊黥囚黢圈輇畎軔軟軾數輸署蜀四思田畋町圖團疃囤畹輞圍畏胃囗軎轄黠軒鴨軋罨軺異軼黟因黝囿圄圉園圓轅圜暫鏨罾軋斬輾罩轍輒畛軫置輊軹軸轉輜罪"
    "岸骯盎岜敗貝崩髀貶豳髕財冊岑崇幬遄幢賜崔嵯丹賧幬嶝迪骶典巔雕崬峒賭髑峨販帆幡豐峯酆幅賦賻賅剛崗岡骼屹購岣骨鶻崮剮過幗咼崞骸骺岵鶻幌賄岌覬嵴岬賤嶠骱巾贐迥崛峻凱剴髁岢崆骷髖貺巋崍嵐嶗嶙嶺髏嶁賂幔帽峁嵋岷內農帕賠帔豈崎岐屺髂嵌岍峭嶠賕曲嶇冉嶸肉山刪贍賒嵊峙贖崧嵩髓炭體貼帖同彤峒骰崴罔巍帷幃崴嵬幄峽峴崤岫峋崖岈巖豔崦央鴦崾貽屹嶷嶧嬰罌鸚由幽嶼峪嵛嶽崽髒贓則幘賊贈嶄帳賬嶂幛賑崢幀幟峙帙周胄貯賺顓幢嵫賺"
    "懊悖鐾必避壁臂璧愎嬖襞忭檗擘怖慘慚孱惻層懺孱羼悵惝怊忱遲尺憧忡惆怵憷愴戳翠悴忖怛蛋憚悼忉翟殿惦刁懂恫惰愕屙飛悱憤怫改敢韝怪慣憾悍憨恨恆惚怙懷慌惶恍悔恢己忌悸屐屆憬局居懼屨慨愷愾慷尻恪快愧悝憒悃懶愣慄悝憐懍鷚戮履屢慢忙眉鶥懵乜民憫愍那惱尼怩尿乜忸懦慪怕怦屁劈譬疋甓屏悽恰慳慊悄憔愀怯愜慊情屈悛韌懾慎屍屎恃蝨收屬疏疋刷司巳悚忪愫韜惕屜悌恬慟恫屠臀惋惘慰尾違韋惟尉屋悟毋忤憮習惜犀屣遐屑懈心忻性悻惺恤胥選迅巽恂疋懨怏已憶翼乙怡翌羿懌悒慵羽愉熨悅慍熨惲韞憎翟展怔咫忮忪惴怍"
    "粑爆焙煸炳燦糙鬯炒焯熾炊叢粗粹燈煅對懟燉煩燔粉糞烽黼黻糕炔焊焓烘糊烀煳煥煌燴火麂糨燼精粳炯炬爝炕糠烤爛勞烙類粒糲煉糧料燎鄰遴粼熘爐烙犖熳煤燜米迷敉粘糯炮粕熗檾煢糗炔燃榮熔糅糝煽剡熵燒糝炻爍燧郯糖烴煺烷煒煨焐熄烯粞滎糈炫煊煙炎焰焱剡烊煬業燁鄴熠營瑩熒螢縈鶯塋滎鎣煜燠糌糟鑿燥炸粘黹燭炷灼焯籽糉鑿"
    "安案襖寶褓被褙裨窆褊裱賓補察衩禪襯宸裎褫寵初褚穿窗祠竄褡襠宕禱定竇裰額福富袱襆祓割袼宮寡褂官冠宄害寒罕鶴褐宏祜宦寰逭禍豁寄寂家袷蹇謇襇窖襟衿窘究裾窶軍皸客窠裉空寇褲窟寬窺襤牢禮褳襝寥寮窿祿褸裸寐袂密祕蜜宓禰冪冥寞衲禰寧甯襻袢袍裨祈祺祁袷騫搴褰襁竅竊寢窮穹祛裙禳衽容冗褥襦賽塞塞衫社神審實視室守祀宋宿邃它袒裼窕祧突褪褪襪窪完宛剜窩寤禧穸禊憲祆祥宵寫袖宿宣穴窨宴窯窈宜寅窨宥宇寓裕窬窳冤運鄆宰竈宅窄寨褶禎鴆之窒祉祗冢宙祝褚窀禚字宗祖祚"
    "錒鎄銨犴鈀鮁鈑鎊包鮑刨狽鋇錛鉍狴鯿鏢鑣鰾鑌鉑鉢鈸鈽鈈猜鑔鍤猹釵鏟鐔猖鯧鈔鐺鋮鴟銃觸雛鋤芻舛釧錘匆猝鑹錯銼鐺島鍀鐙狄邸氐鏑甸鈿釣銚銱鯛鰈釘鋌錠銩獨鍍鍛鐓鈍鐓多鐸鱷鍔鋨鉺鮞犯釩鈁魴鯡狒鐨鱝鋒負匐孵鳧鮒鰒釓鈣鋼鎬鋯鎘鉻鯁觥夠狗勾鉤錮鈷觚鯝鰥逛獷鮭鱖鯀鍋猓鉿鎬狠訇猴忽狐斛猢鸌猾鏵奐鍰郇獾鯇鰉昏獲鍃鈥鑊急鯽鱭鉀鎵鋏鍵鑑鐧鰹角狡鮫鉸解桀鮚金錦鏡鯨獍久灸句鋸鉅鋦狙鐫錈狷獗钁觖鈞鎧鐦鍇鈧銬鈳錁鏗獪狂鯤錕錸鑭狼鋃鐒銠鰳鐳狸鯉鱧鱺猁鋰鏈鐮鰱鐐釕獠獵鱗鈴鯪留劉遛鎦鋶鏤錄魯鱸鑥鋁卵鋝鑼玀鏍獁鰻鏝貿卯錨鉚猸鎇鎂鍆猛錳獼免勉名銘鏌鉬鈉鎿猱鐃鯢猊鈮鯰鯰鳥鑷鎳獰鈕狃釹鍩鈀刨狍錇鈹鮃鉕釙鋪匍鐠鏷鰭錢欠鉛鉗釺鈐鏘錆鏹鍬鍥欽鋟卿鯖鰍犰鴝劬銓然狨銣銳鰓鰠色銫煞鎩釤鱔觴勺猞氏獅鰣鈰鯴狩鑠鍶鎪穌觫狻猻飧鎖鰨鉈獺鮐鈦鐔錟鉭鐋鏜逃鋱銻逖鈿鰷鐵鋌銅鈄兔釷鴕鉈外危猥鮪刎我烏勿鎢鄔夕錫銑狹狎鮮獫銑象鑲銷梟蟹邂獬鑫鋅鐔猩匈鏽鉉鏇鱈旬郇獯鱘遙鑰銚鰩鋣逸鎰猗釔銥鐿印銀銦狺夤迎鏞鱅猶魷鈾銪獄魚狳鈺怨猿鴛眢鑰鉞勻狁鍺鋥鍘詹獐兆釗鍺鎮針錚猙鯖鉦炙觶鍾鍾皺鑄銖錐鐲錙鯔鄒鯫鏃鑽鱒"
    "挨皚捱按氨揞拗翱把拔扒魃捌白擺拜掰捭搬扮拌扳抱卑鵯擯兵摒播撥搏掰帛捕擦採摻操插剎搽拆攙摻抄撤扯抻撐持斥魑抽搐揣搋氚捶攢攛摧措搓挫撮打搭擔撣氮擋搗氘的提抵遞掂掉瓞揲氡抖兜盾遁掇扼摁反返氛扶撫拂氟拊擀扛搞皋擱搿拱掛瓜拐摑摜鬼皈摑氦撼捍撖皓逅換擐皇遑揮攉技擠掎挾皎撟敫撿揀搛攪皎敫撟接捷揭拮近斤揪據拒拘掬捐掘抉攫撅捃揩看抗扛拷氪控扣摳挎魁揆捆括擴拉攔攬撈樂擂魎撩撂捩拎攏摟擄擼捋氯掠掄摞捋抹魅捫描抿摸抹拇捺氖攮撓擬捻攆拈捏擰扭拗挪搦爬扒排拍拚乓拋捧抨批披郫擗撇氕拼拚乒迫魄皤掊撲氣頎掐掮扦搶撬郄擒撳氫氰邱丘泉攘擾扔揉撒搡掃搔殺剎擅摻撣捎攝拾逝誓拭弒手授抒攄摔拴搠撕搜擻損所撻擡探攤搪掏提掭挑挺捅投摶推拖拓挖挽皖魍握撾捂希郗欷掀氙魈攜挾擷欣擤兇揎踅押揠氬掩揚氧搖邀爻拽揶掖抑揖刈挹殷氤攖擁揄援掾樂氳扎拶攢拶皁擇扎揸摘搌找招折哲摺蜇振掙拯指質擲卮摭拄抓爪拽撰撞捉拙擢揍攥撙撮"
    "醃桉柏板棒榜梆杯本標杓彬檳柄柏逋醭材槽查杈楂槎檫郴櫬橙棖酲檉敕醜酬楚櫥杵楮樗椽槌棰醇椿刺樅楱醋酢榱村檔棣柢頂丁酊東棟鶇杜櫝椴柁梵樊礬枋榧焚棼酚楓覆甫敷桴麩概杆橄柑酐槓槁槔歌格哥根梗構枸梏酤栝棺桄桂櫃檜棍槨醢酣杭核橫桁醐槲樺槐桓檜機極棘楫賈枷檢檻柬梘楗校椒酵醮禁槿柩桕桔橘椐枸櫸醵鄄橛桷楷檻栲可柯棵酷枯框醌栝剌來賴賚欄欖婪榔酪醪栳檑酹楞棱李隸櫪櫟醴楝樑椋林檁棱欞柃柳榴櫳樓麓櫨櫓櫚欏榪麥懋梅枚酶楣檬醚棉杪酩模木柰楠釀檸杷攀配醅棚枇票飄瓢剽榀枰樸棋棲杞槭榿遷槍檣橋樵橇覃檎楸麴權醛榷橈榕枘梢森釃杉柵梢杓椹柿釃樹述束梳樞栓速酥粟酸榫梭桫榻酞覃檀樘醣桃梯醍梃桶桐酮酴橢酡柁柝枉桅梧杌西析樨皙檄醯柙杴醯想相橡校枵械榭楔榍醒杏朽栩酗醑楦醺椏檐醃釅樣楊要杳椰椅酏櫻楹酉柚鬱榆櫞櫟樾醞棗札柵榨柞楂棧杖樟棹柘枕甄楨椹榛整枝植櫛枳桎梔酯酎柱株杼櫧樁椎酌梓棕樅醉樽柞酢"
    "矮奧嶴笆稗版般舨笨筆鼻彼篦秕舭篳箅邊籩秉簸舶箔簿艙艚策徜徹掣稱程稱乘懲秤笞篪彳重衝艟愁籌臭稠船舡垂從囪簇徂篡汆矬答笪待簞稻得德等簦第笛糴簟迭牒動冬篼篤牘段短籪躲舵鵝乏筏翻範番繁彷舫篚逢缶復符阜稃馥竿稈缸筻告稿睾篙郜各舸躬篝笱箍鵠刮鴰乖管罐歸龜簋鼾行航和禾很衡後後篌乎戶鵠笏徊徨簧篁徽徊穢和積籍季稽笈稷嵇箕笄稼笳徼簡箭艦箋筧矯徼節街秸筋徑咎矩榘筠靠科稞箜筘筷筐簣籟徠籃稂利黎笠梨籬犁黧篥簾籠簍簏艫律穭籮雒每黴艋艨秒篾敏鰵秣穆年黏臬牛衄筢牌徘盤磐彷逄篷片篇丿笸鄱乞迄憩千籤愆箝喬篋箐筇秋鼽軀衢筌缺穰壬稔入箬穡歃篩舢稍筲艄射舌身矧生升剩甥笙眚師失釋矢舐筮艏術黍秫帥稅私笥聳慫艘簌算穗筍躺甜舔笤廷艇筒透徒禿頹乇籜往委衛微魏逶艉穩無午舞迕系息稀悉徙舾罅先銜舷筅秈向香箱笑簫筱卸囟行秀臭徐籲血循勳徇衙延衍筵鼽秧徉夭徭移役迤艤劓胤郵牖釉籲禹御毓竽箢粵筠贊簪昝造迮笮簀舴怎乍齇笊箴稹徵徵箏知制智秩徵稚雉種重衆舯螽舟籀朱築竹箸竺邾舳篆追自秭笫租纂笮"
    "癌疤辦半瓣瘢癍北背邶迸閉痹辯辨辮瘭癟並病冰部瓿曾差差瘥闡閶癡瘛瘳牀闖瘡次差慈瓷疵鶿餈瘁痤瘥瘩疸癉疸道導弟羝奠癲癜凋疔凍痘端閼閥痱瘋馮贛疳戇羔閣疙羹龔痼關閨袞馘闞閡闔痕閎瘊冱瘓豢癀閽疾冀瘠痂瘕間兼剪煎翦鶼將獎醬姜漿槳交郊竭癤疥羯竟競靖痙疚疽卷眷桊蠲竣開闞閌痾夔閫闊辣瘌癩闌閬癆冷立痢癘癧療冽凜凌羚六瘤龍聾壟癃礱瘻閭瘰美門悶閩閔瘼逆凝瘧判叛爿疲闢痞癖瓶憑剖普前歉牆羌戕羥妾親酋遒癯闃券拳痊瘸闋闕閏颯瘙痧善閃羶鄯疝韶首瘦閂朔槊送凇竦塑遂羧闥癱痰羰疼剃鵜闐痛童痿闈問聞瘟閿痦襲羲瘕閒羨鷳癇冼翔鯗效新辛歆羞券痃癬丫瘂閻閹閆閼兗養羊癢恙瘍冶意義益毅疫痍瘞癔翊音癮癭癰猷疣閾瘐瘀閱韻奘甑閘痄瘵站章彰瘴鄣着着疹鄭症痔痣瘃疰裝狀壯妝奘戇着資姿恣孳粢尊遵"
    "嬡媼婢妣婊奼嬋娼嫦巢媸巛妲逮刀嫡娣妒娥婀妨妃婦旮艮媾姑嬀好劃畫婚即既姬嫉妓暨嫁建奸嬌姣剿姐婕盡妗婧九鳩娟君郡馗邋姥嫘娌逯媽嬤妹媒媚娩妙嫫姆娜奶嫩妮娘嫋妞怒努奴弩駑胬孥女媲嫖姘嬪娉嬙羣嬈忍刃妊如嫂姍嬗邵劭嬸娠始書恕姝孀妁姒肅她帑迢婷退娃媧婉丸娓嫵媳嬉嫌嫻姓絮旭婿尋巡婭妍嫣姚妖姨姻尹邕娛嫗妤聿媛災甾嫜召晝帚妯姊"
    "俺傲八爸伯佰伴頒傍保飽堡煲備倍憊坌俾便飈颮儐餅伯餑倉傖側岔餷儕饞償倡倘倀傖侈飭傺仇讎儔儲傳創促催隹代袋貸黛岱傣但儋倒登鄧凳低佃爹佚仃侗兌朵剁俄餓餌佴發伐垡飯凡仿分份忿僨風鳳俸佛父付佛伏傅俯斧俘釜伽個鴿頜仡公供佝谷估僱館倌劊傀癸含頷何合盒頜候侯餱化凰會餛貨集飢祭伎偈佶價假佳佼僥伽件健劍儉僭餞牮僵焦餃佼僥僬鷦介借傑偈進今僅饉儆僦俱颶倨倦雋倔俊雋佧侃龕伉倥侉會儈鄶饋傀佬仂儡例俐俚儷傈倆斂倆僚賃領令伶翎瓴餾僂侶倫侖倮饅們命饃侔仫拿佴饢餒恁你倪伲念您恁佞儂儺偶俳佩盆僻仳便偏貧俜僕企俟伽倩僉仟戧僑俏劁伽侵禽衾傾俅全卻饒人任仁飪仞仍儒偌仨傘饊僧傻傷舍佘畲歙什伸使食飾蝕侍仕售舒俞倏毹殳雙似伺飼俟頌餿颼俗夙僳隼他貪倘餳儻絛倜條佻停佟侗仝偷途飩氽佗佤位偉僞偎翁倭伍侮仵兮翕僖歙餼俠仙餡像餉斜偕信餳修休饈鵂敘儇伢儼偃仰佯餚僥爺依億伊儀倚佚仡佾飴飲傭俑優悠佑攸侑餘欲愈餘逾俞覦傴俁飫鵒龠仔債佔仗仉偵值侄仲住佇侏傳饌僮隹倬仔傯俎作做坐佐"
    "絆綁鴇繃比匕弼毖編緶繽剝纏綽弛綢絀純綽紿彈締綈斷緞綞紡費緋紛縫弗縛艴紱紼紺綱縞紇給綆弓緱貫綸緄絎紇紅弘弧緩幻繯繪繢幾給級紀繼績緝畿緘縑強疆犟繮絳繳絞結皆縉經弳糾絹絕緙絝纊纜縲蠡縭練繚綾綹綠縷綸絡縵彌弭糸緬綿黽繆緲緡黽繆繆母納紐轡紕緶縹綺纖繾繰頃綣強繞紉絨縟弱繰繅紗繕紹紳繩綬紓絲鷥緦綏縮彈緹綈統彖紈綰網維緯紋細線弦纖鄉響饗緗綃纈紲繡續緒絢幺疑繹彝縊肄引穎纓潁幼粥鬻紆緣約紜繰繒綻張縝織紙旨彘終粥紂縐綴縋緇總縱綜組纘"
    "庵鏖廒庇庳廁廛廁廛廠廚底店度府腐庚賡廣庋麂廑廄麇康庫鄺廓廊廉廖麟廩鹿廬麻麼麼糜靡糜麋縻廟麼磨摩魔龐庖庀廑慶麇廈麝庶廝唐庭廳庹廡席廈廂庠廨庥序膺鷹應庸庾遮鷓麈座哀諳謗褒變遍扁卞斌稟亳詫產顫諂讒昶讖諶誠啻充畜鶉詞卒誕讜帝敵詆諦丶調諜訂讀憝敦訛諤誒方放房訪邡誹扉諷訃該高膏誥詬顧詁詿詭郭裹亥頏毫豪訶劾亨訌護戽扈話譁謊肓諱誨詼諢記計劑譏詰齏齎肩諫譾講誡詰訐謹京旌扃就鷲詎訣譎亢刻課頦誇誆誑斕讕朗郎羸誄裏離戾戀良亮諒吝旒旅率膂巒攣孿欒鑾孌鸞臠論蠃蠻謾盲氓邙袤旄謎謐謬謨謀畝訥旎諾謳旁旆烹翩扁諞評裒譜齊旗棄啓訖綮牽謙譴敲誚譙請綮詘詮讓瓤認扇訕商設誰詵諗市識詩試施適諡熟孰塾率衰誰說誦訟訴謖誶談譚討調亭託彎望忘亡妄謂諉文紊甕於誤誣享詳襄謝諧褻燮許畜詡旋玄諼謔詢訓訊訝言顏諺彥讞謠夜謁議衣譯亦誼裔弈奕詣旖詒贏嬴永詠雍壅饔遊誘於語育於諭諛雜譖詐齋氈譫旃肇詔這謫診證諍衷州謅主諸誅諄諑諮諮諏族卒詛"
    "")
  "ASCII char to traditional Chinese characters with wubi char table.
Powered by OpenCC. Thanks to BYVoid.")

(defvar pinyinlib--punctuation-alist
  '((?. . "[。.]")
    (?, . "[，,]")
    (?? . "[？?]")
    (?: . "[：:]")
    (?! . "[！!]")
    (?\; . "[；;]")
    (?\\ . "[、\\]")
    (?\( . "[（(]")
    (?\) . "[）)]")
    (?\< . "[《<]")
    (?\> . "[》>]")
    (?~ . "[～~]")
    (?\' . "[‘’「」']")
    (?\" . "[“”『』\"]")
    (?* . "[×*]")
    (?$ . "[￥$]")))

(defun pinyinlib--get-simplified-char-table ()
  "Get the simplified char table."
  (cl-case pinyinlib-char-table-type
    ('wubi pinyinlib--wubi-simplified-char-table)
    ('pinyin pinyinlib--pinyin-simplified-char-table)
    ('mix (seq-mapn #'concat
                    pinyinlib--wubi-simplified-char-table
                    pinyinlib--pinyin-simplified-char-table))))

(defun pinyinlib--get-traditional-char-table ()
  "Get the traditional char table."
  (cl-case pinyinlib-char-table-type
    ('wubi pinyinlib--wubi-traditional-char-table)
    ('pinyin pinyinlib--pinyin-traditional-char-table)
    ('mix (seq-mapn #'concat
                    pinyinlib--wubi-traditional-char-table
                    pinyinlib--pinyin-traditional-char-table))))

(defun pinyinlib-build-regexp-char
    (char &optional no-punc-p tranditional-p only-chinese-p mixed-p)
  (let ((diff (- char ?a))
        (pinyinlib--simplified-char-table (pinyinlib--get-simplified-char-table))
        (pinyinlib--traditional-char-table (pinyinlib--get-traditional-char-table))
        regexp)
    (if (or (>= diff 26) (< diff 0))
        (or (and (not no-punc-p)
                 (assoc-default
                  char
                  pinyinlib--punctuation-alist))
            (regexp-quote (string char)))
      (setq regexp
            (if mixed-p
                (concat (nth diff pinyinlib--traditional-char-table)
                        (nth diff pinyinlib--simplified-char-table))
              (nth diff
                   (if tranditional-p
                       pinyinlib--traditional-char-table
                     pinyinlib--simplified-char-table))))
      (if only-chinese-p
          (if (string= regexp "")
              regexp
            (format "[%s]" regexp))
        (format "[%c%s]" char
                regexp)))))

(defun pinyinlib-build-regexp-string
    (str &optional no-punc-p tranditional-p only-chinese-p mixed-p)
  (mapconcat (lambda (c) (pinyinlib-build-regexp-char
                          c no-punc-p tranditional-p only-chinese-p mixed-p))
             str
             ""))

(provide 'pinyinlib)
;;; pinyinlib.el ends here
