# confparser
## Simple English
conf file parser for Liberty Eiffel

## 日本語での説明
Unixでよく設定ファイルとして使われるconfファイルを読み込むLiberty Eiffelのクラス(confparser.e)です。動作の詳細については、confparser_test.eにsample.confを引数として与える実際の動作を確認するのが早いと思います。


### 動作例
confparser_test.eコンパイルして、コマンドライン引数としてsample.confを指定すると

	./a.out sample.conf

こんな結果になります。

	key1: new_value1
	key2: new value2
	key3: value3
	key4: value4
	key5: value5


### confファイルの書式について
以下の通りです。Eiffelっぽいコメントも認める以外は普通なのではと思っています。

- "#"または"--"で始まる行はコメント行です。（それ以上読み込みません。）
- （コメント行以外の）行は以下のような形式を想定しています。
  - "key"、"空白"、"value"[、"空白"、["#"または"--"、コメント]]
- 空白はタブもしくはスペースのことで、いくつ連続しても構いません。
- valueの後ろに、（#または--で始めることで）コメントが書けます。
- valueが空白を含む場合には「"」で囲んでください。
- 同じkeyの行が複数ある場合には、最後に指定されたものが有効になります。
