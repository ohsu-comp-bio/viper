# Conda package build script
mkdir -p $PREFIX/bin
cp $RECIPE_DIR/run_aracne2regulon.r $PREFIX/bin
cp $RECIPE_DIR/run_viper.r $PREFIX/bin
cp $RECIPE_DIR/viper_report.r $PREFIX/bin
