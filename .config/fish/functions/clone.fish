function clone --description 'Clone repo to ~/dev'
	cd ~/dev && git clone git@github.com:$argv[1].git $argv[2]
end
