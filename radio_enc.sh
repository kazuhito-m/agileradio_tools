#!/bin/bash -x

# agileradioのmp3エンコード＆タグ情報埋め込みスクリプト
# Usage. [this script] [source WAV file]
# Require commands - expr , lame , eyed3

# 定数

# mp3のサイズの限界		
MAX_MP3_SIZE=`expr 20 \* 1024 \* 1024`
# 結果ファイル
RESULT_FILE=${1%.*}.mp3

# 処理

# lameに「mp3の圧縮レベル」を渡してMAXを切るまで変換し続ける
for level in $(seq 7 10); do
	echo "Try encoding Level ${level}"
	# 変換
	lame -V ${level} ${1}
	# サイズ取得
	mp3_size=`du -sb $RESULT_FILE | cut -nf 1`
	# 下回ってるか比較
	if [ ${mp3_size} -le ${MAX_MP3_SIZE} ] ; then
		break #期待どおりのサイズになったので脱出
	fi
done

echo "Mp3 encoding done."

# mp3/ID3 タグ付与
# eyeD3コマンドを期待。無い場合は "sudo apt-get install eyeD3"

# 設定ファイル読み込み
. mp3id3tag_settings.sh

# Tagの書き込み (yearが効かないなど、いくつか不思議な項目がある)
# 定義はこちらを参照。http://wikiwiki.jp/qmp/?Plugins%2FLibraries%2FTag%20Editors%2FID3%20Tags#x9ba4c18

eyeD3 --to-v2.4 --set-encoding=utf8 --artist="${ARTIST}" --album="${TITLE_BASE}" --title="${FULL_TYTLE}" --year=${MAKE_YEAR} --publisher=publisher --comment=jp:abc:"${TITLE_COMMENT}" --add-image=./agileradio.jpg:OTHER:agileradio.jpg  --set-user-url-frame="Description:${SITE_URL}" --set-user-text-frame="Description:${ARTIST}" --genre=radio --set-text-frame=TPE2:"${A_ARTIST}" --set-text-frame=TCOM:"${COMMPOSER}" --set-text-frame=TDAT:"${MAKE_YEAR}" --set-text-frame=TCOP:"${A_ARTIST}" --set-text-frame=TENC:lame ${RESULT_FILE}

# 仕上げ。リネーム
mv "${RESULT_FILE}" "${NAME_BASE}_ite${ITE_NO}.mp3"

echo "Radio encode operation done!"
