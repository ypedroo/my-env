# my-hyper-config-files

Useful extensions for Zsh for WSL using Ubuntu.

## Requeriments
<ol>
<li>Zsh</li>
<li>Oh My Zsh</li>
<li>WSL</li>
</ol>
 
## Extensions
<ol>
<li>zsh-syntax-highlighting</li>
<li>zsh-autosuggestions</li>
<li>fzf</li>
<li>hypernpm</li>
<li>hyperterm-summon</li> 
</ol>
 
 ## Themes
<ol>
<li>verminal</li>
<li>hyper-corubo</li>
<li>hyperterm-chesterish</li>
<li>hyper-night-owl</li>
</ol>

## Instalation
### For the ZHS:</br>
**Oh My Zsh:</br>**
<br/>
curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh; zsh
<br/>
<br/>
**zsh-syntax-highlighting:**<br/>
<br/>
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting <br/>
<br/>
**zsh-autosuggestions:<br/>**
<br/>
<br/>
git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions<br/>
<br/>
<br/>
**fzf:<br/>**
<br/>
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install
<br/>
<br/>
After git clone run **nano ~/.zshrc**  and add on the plugins array as the img:</br>
![alt text](https://github.com/ypedroo/my-hyper-config-files/blob/master/assets/Anota%C3%A7%C3%A3o%202019-03-19%20120738.png)
### For the Hyper Config:<br/>
Open Hyper and type Ctrl + , then
copy the Js file and paste it to the .hyper.js file.

## Special Thanks
[This awesome article of @Ivan Augusto](https://medium.com/@ivanaugustobd/seu-terminal-pode-ser-muito-muito-mais-produtivo-3159c8ef77b2)



