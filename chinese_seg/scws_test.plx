use Text::Scws;
use Encode;
$scws = Text::Scws->new();
$scws->set_charset("utf8");
$scws->set_dict('/usr/local/etc/dict.utf8.xdb');
$scws->set_rule('/usr/local/etc/rules.utf8.ini');
$scws->set_ignore(1);
$scws->set_multi(1);
$s = "我是一个中国人。主要功能包括中文分词；词性标注；命名实体识别；新词识别；同时支持用户词典。ICTCLAS经过五年精心打造，内核升级6次，目前已经升级到了ICTCLAS3.0，分词精度98.45%，各种词典数据压缩后不到3M。ICTCLAS在国内973专家组组织的评测中活动获得了第一名，在第一届国际中文处理研究机构SigHan组织的评测中都获得了多项第一名，是当前世界上最好的汉语词法分析器。";
$scws->send_text($s);
while ($r = $scws->get_result()) {
	foreach (@$r) {
		print "<",$_->{word},">\t";
  	}
}
print "\n";
