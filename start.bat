@echo off
setlocal enabledelayedexpansion
:: 테스트용
:: UTF-8 설정
chcp 65001 > nul

:: 수집 시작 메시지 출력
echo Windows Incident Analysis Report
echo ==============================
echo Report Generated: %date% %time%
echo ==============================

:: Process 정보 수집
echo [Process Information]
echo 현재 실행 중인 프로세스를 나열합니다.
tasklist
if not exist "%~dp0\log" (
    mkdir "%~dp0\log"
)
tasklist > "%~dp0\log\Process.txt"
echo ----------------------------------------

:: Event Log 정보 수집
echo [Event Log Information]
echo 최근 시스템 이벤트 로그를 수집합니다.
wevtutil qe System /rd:true /f:text
wevtutil qe System /rd:true /f:text > "%~dp0\log\Event.txt"
echo ----------------------------------------

:: MFT (Master File Table) 정보 수집 - 접근 권한 필요 (관리자 권한 필수)
echo [MFT Information]
:: echo Master File Table 정보는 별도의 도구가 필요합니다.
:: echo Windows 기본 명령으로는 MFT 정보 수집이 제한됩니다.
cd "%~dp0\etc\forecopy_handy(v1.2)
call "forecopy_handy" -m ..\..\
echo .\MFT\ 경로애 MFT 파일이 생성되었습니다.
echo ----------------------------------------

:: Prefetch 파일 목록 수집
echo [Prefetch Information]
echo Prefetch 디렉토리의 파일 목록을 수집합니다.
:: dir %SystemRoot%\Prefetch
call "forecopy_handy" -p ..\..\
cd ..\..\
dir "%~dp0\prefetch" > "%~dp0\log\Prefetch.txt"
echo ----------------------------------------

:: Browser 히스토리 수집
echo [Browser Information]
echo IE 및 Chrome의 일부 히스토리를 확인합니다.
echo Internet Explorer History:
dir "%userprofile%\AppData\Local\Microsoft\Windows\History"
dir "%userprofile%\AppData\Local\Microsoft\Windows\History" > "%~dp0\log\Explorer_History.txt"
echo Chrome History:
dir "%userprofile%\AppData\Local\Google\Chrome\User Data\Default\History"
dir "%userprofile%\AppData\Local\Google\Chrome\User Data\Default\History" > "%~dp0\log\Chrome_History.txt"
echo ----------------------------------------

:: Persistence (시작 프로그램 목록) 수집
echo [Persistence Information]
echo 시작 프로그램에 등록된 목록을 나열합니다.
reg query "HKLM\Software\Microsoft\Windows\CurrentVersion\Run"
reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Run"
reg query "HKLM\Software\Microsoft\Windows\CurrentVersion\Run" > "%~dp0\log\Persistence.txt"
reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" >> "%~dp0\log\Persistence.txt"
echo ----------------------------------------

:: Registry - 최근 실행된 프로그램 목록 수집
echo [Registry Information]
echo 최근 실행된 프로그램에 대한 레지스트리 정보를 수집합니다.
reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU"
reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU" > "%~dp0\log\Registry.txt"
echo ----------------------------------------

:: 완료 메시지
echo 아티팩트 수집이 완료되었습니다.
pause
