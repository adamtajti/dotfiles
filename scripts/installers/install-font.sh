!#/bin/bash

wget https://github.com/IdreesInc/Monocraft/releases/download/v3.0/Monocraft-nerd-fonts-patched.ttf
mv Monocraft-nerd-fonts-patched.ttf ~/.fonts

fc-cache -fv
exit 0

# install CascadiaCode Nerd Font --> u can choose another at: https://www.nerdfonts.com/font-downloads
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/CascadiaCode.zip
unzip CascadiaCode.zip -d ~/.fonts


# install IBMPlexMono Nerd Font --> u can choose another at: https://www.nerdfonts.com/font-downloads
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/IBMPlexMono.zip
unzip IBMPlexMono.zip -d ~/.fonts

# install Iosevka Nerd Font --> u can choose another at: https://www.nerdfonts.com/font-downloads
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/Iosevka.zip
unzip Iosevka.zip -d ~/.fonts

# install ProggyClean Nerd Font --> u can choose another at: https://www.nerdfonts.com/font-downloads
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/ProggyClean.zip
unzip ProggyClean.zip -d ~/.fonts

# install SpaceMono Nerd Font --> u can choose another at: https://www.nerdfonts.com/font-downloads
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/SpaceMono.zip
unzip SpaceMono.zip -d ~/.fonts

# install Terminus Nerd Font --> u can choose another at: https://www.nerdfonts.com/font-downloads
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/Terminus.zip
unzip Terminus.zip -d ~/.fonts


# install Hermit Nerd Font --> u can choose another at: https://www.nerdfonts.com/font-downloads
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/Hermit.zip
unzip Hermit.zip -d ~/.fonts

# install FiraMono Nerd Font --> u can choose another at: https://www.nerdfonts.com/font-downloads
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/FiraMono.zip
unzip FiraMono.zip -d ~/.fonts

# install BigBlueTerminal Nerd Font --> u can choose another at: https://www.nerdfonts.com/font-downloads
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/BigBlueTerminal.zip
unzip BigBlueTerminal.zip -d ~/.fonts

# install NerdFontsSymbolsOnly Nerd Font --> u can choose another at: https://www.nerdfonts.com/font-downloads
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/NerdFontsSymbolsOnly.zip
unzip NerdFontsSymbolsOnly.zip -d ~/.fonts

fc-cache -fv
echo "done!"

