cd ..
BASE_DIR=$PWD
PROJECT=skin.estuary.ukfta
SRC_DIR=$BASE_DIR/$PROJECT
OUT_DIR=$BASE_DIR/output
PROJECT_OUT_DIR=$BASE_DIR/output/$PROJECT
ADDONXML=${SRC_DIR}/addon.xml
VERSION=$(grep "<addon id=\"${PROJECT}\" version=" ${ADDONXML} | sed 's/.*version=\"\([[:digit:]\|\.]*\).*/\1/')
ZIPFILE=${PROJECT}-${VERSION}.zip

echo ----------------------------------------
echo Creating Estuary Build Folder
rm -R -f $PROJECT_OUT_DIR >/dev/null 2>&1
mkdir -p $PROJECT_OUT_DIR/media

echo .svn>exclude.txt
echo .git>>exclude.txt
echo .gitignore>>exclude.txt
echo Thumbs.db>>exclude.txt
echo Desktop.ini>>exclude.txt
echo dsstdfx.bin>>exclude.txt
echo build.sh>>exclude.txt
echo media/>>exclude.txt
echo themes/>>exclude.txt
echo exclude.txt>>exclude.txt

echo ----------------------------------------
echo Creating XBT File...
TexturePacker -dupecheck -input $SRC_DIR/media -output $PROJECT_OUT_DIR/media/Textures.xbt
TexturePacker -dupecheck -input $SRC_DIR/themes/curial -output $PROJECT_OUT_DIR/media/curial.xbt
TexturePacker -dupecheck -input $SRC_DIR/themes/flat -output $PROJECT_OUT_DIR/media/flat.xbt

echo ----------------------------------------
echo XBT Texture Files Created...
echo Building Skin Directory...
rsync -av --exclude-from=exclude.txt $SRC_DIR $OUT_DIR
rm exclude.txt

echo ----------------------------------------
echo Creating ZIP File...
cd $OUT_DIR
rm -f ${ZIPFILE} >/dev/null 2>&1
zip -r ${ZIPFILE} ${PROJECT}
rm -r -f $PROJECT_OUT_DIR
