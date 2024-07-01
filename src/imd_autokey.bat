rem This is a separate solution

rem Generate AutoKey File
echo "C:" CR > %archive_path%\imd_key.fil
echo "CD \" CR >> %archive_path%\imd_key.fil
echo "CD %IMD_PATH%" CR >> %archive_path%\imd_key.fil
echo "IMD.COM /H /A D=%archive_path%" CR >> %archive_path%\imd_key.fil
echo "r" CR >> %archive_path%\imd_key.fil
echo "%diskname%" CR >> %archive_path%\imd_key.fil
echo "%comment%" CR >> %archive_path%\imd_key.fil
echo CR >> %archive_path%\imd_key.fil

echo ESC >> %archive_path%\imd_key.fil
echo ESC >> %archive_path%\imd_key.fil
echo ESC >> %archive_path%\imd_key.fil
echo ESC >> %archive_path%\imd_key.fil
echo ESC >> %archive_path%\imd_key.fil

echo "CD %ARCHIVER_PATH%" CR >> %archive_path%\imd_key.fil
