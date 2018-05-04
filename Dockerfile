FROM r-base:3.2.3
WORKDIR /opt/viper
VOLUME /opt/viper
ADD run_viper.r /opt/viper/run_viper.r
ADD run_aracne2regulon.r /opt/viper/run_aracne2regulon.r
ADD viper_report.r /opt/viper/viper_report.r
ADD install_packages.r /opt/viper/install_packages.r
RUN Rscript /opt/viper/install_packages.r
CMD ["Rscript", "/opt/viper/run_viper.r"]
