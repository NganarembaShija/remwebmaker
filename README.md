#Copy paste the codes below to Install this on Termux
--------------------------------------
yes | pkg update;
yes | pkg upgrade;
yes | pkg install git;
git clone https://github.com/NganarembaShija/remwebmaker;
cd remwebmaker;
mv webmaker.sh go;
chmod +x go;
mkdir $HOME/bin;
mv go $HOME/bin/;
PATH=$PATH:$HOME/bin;
go
----------------------------------------
#Notes
* To run the script just write "go" and Press Enter.
* You need ngrok token for the first time setup
  Sign up to ngrok and get your token (You can use any email which doesn't even exist)

Click this link to sign up to ngrok : https://dashboard.ngrok.com/signup

Just copy paste your ngrok token when Ask!
( token looks like... 1zfyddydrubk633ghjjb... which is after the code ./ngrok authtoken 1yfhvjijjj...)

* Press Ctrl+c to stop the script

That's it. 

