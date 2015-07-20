CALL gem install bundler
CALL gem install rspec

REM Build and install ms-rest
cd /d %~dp0\ms-rest
CALL build_gem.bat
CALL install_gem.bat

REM Build and install ms-rest-azure
cd /d %~dp0\ms-rest-azure
CALL build_gem.bat
CALL install_gem.bat

cd /d %~dp0