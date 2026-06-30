@echo off
REM PetHome 编译脚本
REM 依赖: curl, Java 17+, 需联网下载 servlet-api

setlocal enabledelayedexpansion
set PROJECT_DIR=D:\DevelopTools\PetHome
set CLASSES_DIR=%PROJECT_DIR%\web\WEB-INF\classes
set LIB_DIR=%PROJECT_DIR%\web\WEB-INF\lib
set SRC=%PROJECT_DIR%\web\src
set TMP=%TEMP%\pethome-compile

if not exist "%TMP%" mkdir "%TMP%"

REM 下载 servlet API (仅在本地没有时)
if not exist "%TMP%\jakarta.servlet-api-6.1.0.jar" (
    echo Downloading Jakarta Servlet API 6.1.0...
    curl -sL "https://repo1.maven.org/maven2/jakarta/servlet/jakarta.servlet-api/6.1.0/jakarta.servlet-api-6.1.0.jar" -o "%TMP%\jakarta.servlet-api-6.1.0.jar"
)

set CP="%TMP%\jakarta.servlet-api-6.1.0.jar;%LIB_DIR%\mysql-connector-j-9.7.0.jar;%SRC%"

echo Compiling DAOs/Models...
javac -cp %CP% -d "%CLASSES_DIR%" ^
    "%SRC%\com\pethome\model\Category.java" ^
    "%SRC%\com\pethome\dao\CategoryDao.java" ^
    "%SRC%\com\pethome\dao\BaseDao.java" ^
    "%SRC%\com\pethome\dao\ProductDao.java" ^
    "%SRC%\com\pethome\model\Product.java" ^
    "%SRC%\com\pethome\util\DBUtil.java"
if %ERRORLEVEL% neq 0 (
    echo [ERROR] DAOs compilation failed
    exit /b 1
)
echo [OK] DAOs compiled

set CP2="%TMP%\jakarta.servlet-api-6.1.0.jar;%LIB_DIR%\mysql-connector-j-9.7.0.jar;%CLASSES_DIR%"

echo Compiling Servlets...
javac -cp %CP2% -d "%CLASSES_DIR%" ^
    "%SRC%\com\pethome\servlet\ProductServlet.java" ^
    "%SRC%\com\pethome\servlet\AdminServlet.java"
if %ERRORLEVEL% neq 0 (
    echo [ERROR] Servlets compilation failed
    exit /b 1
)
echo [OK] Servlets compiled
echo.
echo All compiled successfully!
