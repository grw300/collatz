export TMP='/tmp'
mkdir -p $TMP

export _NIBUILD_SETUPENV_DIR=./objects/_dependencies/build
export _NIBUILD_SETUPENV_IGNORECACHE=
if [ "$NIBUILD_SETUPENV_DIR" != "" ]; then
   export _NIBUILD_SETUPENV_DIR=$NIBUILD_SETUPENV_DIR
   export _NIBUILD_SETUPENV_IGNORECACHE=--ignoreCache
fi

if [ -r "buildToolsRedirect.pl" ]; then
   perl buildToolsRedirect.pl --setupEnvVersion=4 \
      --scriptType=sh \
      --cacheDir=$_NIBUILD_SETUPENV_DIR \
      $_NIBUILD_SETUPENV_IGNORECACHE \
      $1 $2 $3 $4 $5 $6 $7 $8 $9

   if [ $? != 0 ]; then
      echo ""
      echo "[setupEnv.sh]"
      echo "ERROR: Unable to locate the toolchain on your disk."
      echo "The helper app, buildToolsRedirect.exe, returned an error."
      return 1
   fi
else
   echo ""
   echo "[setupEnv.sh]"
   echo "ERROR: The script buildToolsRedirect.pl is not present in"
   echo "the same directory as setupEnv.sh.  Be sure that you have"
   echo "correctly integrated the build tools into your dependencies."
   echo "Also be sure to run this script from your component's trunk directory."
   return 1
fi

if [ -r "$_NIBUILD_SETUPENV_DIR/fixupPath.sh" ]; then
   . $_NIBUILD_SETUPENV_DIR/fixupPath.sh || return 1
else
   echo "buildToolsRedirect.pl did not output the path fixup"
   return 1
fi

return 0
