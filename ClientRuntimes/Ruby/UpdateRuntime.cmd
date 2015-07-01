CALL gem install bundler
CALL gem install rspec

REM Build and install ms-rest
cd /d %~dp0\ms-rest
CALL build_gem.bat
CALL install_gem.bat

cd /d %~dp0