os.remove("ms0:/PSP/GAME/PSPeasyinstall/cache/installer.zip")

chargementcomplet = false
chargemenu = false
menu = {}
posmenu = 1
posmenulimit = 1
menudesc = {}
imgmenu = {}

categories = false
chargecat = false
cat = {}
poscat = 1
poscatlimit = 1
imgcat = {}
tricat = 1
maxtricat = 3

article = false
chargearticle = false
artnote = {}
artdev = {}
arttexte = {}
artimage = {}
artlien = {}
artpath = {}
artid = {}
artdate = {}

debuttelechargement = false
telechargement = false
fintelechargement = false
debutinstallation = false
installationencours = false
fininstallation = false
debutfinition = false
finitionencours = false
finfinition = false
dejainstalle = false
procinstall = false

usbnonactive = true

recherchenonactive = true
recherche = ""
alphabet = {"A","Z","E","R","T","Y","U","I","O","P","Q","S","D","F","G","H","J","K","L","M","W","X","C","V","B","N"}
posalphabet = 1

state = -1

blanc = pge.gfx.createcolor(255, 255, 255)
rouge = pge.gfx.createcolor(255, 0, 0)
grisfonce = pge.gfx.createcolor(38, 38, 38)
noiralpha = pge.gfx.createcolor(0,0,0,240)

dicot10 = pge.font.load("dicot.ttf", 11, PGE_RAM)
if not dicot10 then
	error("Failed to load font.")
end
dicot14 = pge.font.load("dicot.ttf", 14, PGE_RAM)
if not dicot14 then
	error("Failed to load font.")
end

fond = pge.texture.load("fond.png", PGE_RAM, true)
if not fond then
    error("Failed to load var fond")
end

installer_btn = pge.texture.load("installer.png", PGE_RAM, true)
if not installer_btn then
    error("Failed to load var image")
end

installe_btn = pge.texture.load("installe.png", PGE_RAM, true)
if not installe_btn then
    error("Failed to load var image")
end

if not pge.net.init() then
	error("Error on net init.")
end

if not pge.utils.netinit() then
	error("Error on net dialog init.")
end

-- Init USB and check it was successful
if not pge.usb.init() then
	error("Failed to init USB.")
end

function string:split(delimiter)
  local result = { }
  local from  = 1
  local delim_from, delim_to = string.find( self, delimiter, from  )
  while delim_from do
    table.insert( result, string.sub( self, from , delim_from-1 ) )
    from  = delim_to + 1
    delim_from, delim_to = string.find( self, delimiter, from  )
  end
  table.insert( result, string.sub( self, from  ) )
  return result
end

function exectri()
	if tricat == maxtricat then
	tricat = 1
	else
	tricat = tricat + 1
	end
	chargecat = false
end

function boutoninstall()
	if dejainstalle then
		installe_btn:activate()
		installe_btn:draweasy(375, 30)
		finfinition = false
	else
		installer_btn:activate()
		installer_btn:draweasy(375, 30)
	end
end

function install()
	if dejainstalle then
	dejala = "oui"
	else
	dejala = "non"
	end
	if dejala == "non" then
	debuttelechargement = true
	procinstall = true
	end
end

function testdejainstalle(path)
	result = pge.file.exists("ms0:/".. path .."/pspeasyinstall.txt")
	if result then
	dejainstalle = true
	end
end

function creertxt(path,txt)
file = io.open("ms0:/".. path .."/pspeasyinstall.txt", "w")
file:write(txt)
file:close()
finfinition = true
finitionencours = false
debutfinition = false
end


function installzip()
	result = pge.file.exists("cache/installer.zip")
	if result then
		myzip = pge.zip.open("cache/installer.zip")
		yo = pge.dir.chdir("ms0:/")
		zipok = pge.zip.extract(myzip)
		if zipok then
			installationencours = false
			debutinstallation = false
			fininstallation = true
			yo = pge.dir.chdir("ms0:/PSP/GAME/PSPeasyinstall")
		end
	end
end

function loadzip(lien)
	pge.net.getfile(lien, "cache/installer.zip")
	fintelechargement = true
	debuttelechargement = false
	telechargement = false
end

function loadimgart(num)
	pge.net.getfile(artimage[num], "cache/imgarticle.png")
	imagearticle = pge.texture.load("cache/imgarticle.png", PGE_RAM, true)
	chargearticle = true
end

function loadimg(num)
	for i=1,num do
		imgcat[i] = pge.texture.load("cache/cat"..i..".png", PGE_RAM, true)
	end
end

function loadimagecat(num)
	for i=1,num do
		imgmenu[i] = pge.texture.load("cache/imgmenupos"..i..".png", PGE_RAM, true)
	end
	chargementcomplet = true
end

function loadDataCat(menuPos,trieur)
	if state == 0 then
	if menu[posmenu] == "Recherche" then
	success, reponse = pge.net.postform("http://www.mileskabal.com/pspinstaller/index.php", "recherche="..menuPos.."&tri="..trieur, 8192)
	else
	success, reponse = pge.net.postform("http://www.mileskabal.com/pspinstaller/index.php", "menu="..menuPos.."&apps="..menuPos.."&tri="..trieur, 8192)
	end
	array = string.split(reponse,"*")
	nbrarray = table.getn(array)
	for i = 1,nbrarray do
		array2 = string.split(array[i],";")
		nbrarray2 = table.getn(array2)
		poscatlimit = nbrarray2
		if i == 1 then
			for j = 1,nbrarray2 do
			cat[j] = array2[j]
			end
		end
		if i == 2 then
			for j = 1,nbrarray2 do
			pge.net.getfile(array2[j], "cache/cat"..j..".png")
			end
		end
		if i == 3 then
			for j = 1,nbrarray2 do
			artnote[j] = array2[j]
			end
		end
		if i == 4 then
			for j = 1,nbrarray2 do
			artdev[j] = array2[j]
			end
		end
		if i == 5 then
			for j = 1,nbrarray2 do
			arttexte[j] = array2[j]
			end
		end
		if i == 6 then
			for j = 1,nbrarray2 do
			artimage[j] = array2[j]
			end
		end
		if i == 7 then
			for j = 1,nbrarray2 do
			artlien[j] = array2[j]
			end
		end
		if i == 8 then
			for j = 1,nbrarray2 do
			artpath[j] = array2[j]
			end
		end
		if i == 9 then
			for j = 1,nbrarray2 do
			artid[j] = array2[j]
			end
		end
		if i == 10 then
			for j = 1,nbrarray2 do
			artdate[j] = array2[j]
			end
		end
		
	end
	
	
	chargecat = true
	else
	chargecat = false
	end
end

function loadData(menuPos)
	if state == 0 then
		success, reponse = pge.net.postform("http://www.mileskabal.com/pspinstaller/index.php", "menu="..menuPos, 4096)
		array = string.split(reponse,"*")
		nbrarray = table.getn(array)
		for i = 1,nbrarray do
			array2 = string.split(array[i],";")
			nbrarray2 = table.getn(array2)
			posmenulimit = nbrarray2
			if i == 1 then
				for j = 1,nbrarray2 do
				menu[j] = array2[j]
				end
			end
			if i == 2 then
				for j = 1,nbrarray2 do
				menudesc[j] = array2[j]
				end
			end
			if i == 3 then
				for j = 1,nbrarray2 do
				pge.net.getfile(array2[j], "cache/imgmenupos"..j..".png")
				end
			end
		end
		
		
		table.insert(menu,"Recherche")
		table.insert(menudesc,"Recherche")
		table.insert(menu,"USB")
		table.insert(menudesc,"Connexion USB")
		table.insert(menu,"Aide")
		table.insert(menudesc,"Croix : Valider - Ecrire\nRond : Retour\nStart : Installer - Recherche\nCarre : Tri (date-titre-note) - Effacer")
		table.insert(menu,"Quitter")
		table.insert(menudesc,"Quitter PSP Easy Installer")
		posmenulimit = posmenulimit + 4

		loadimagecat(posmenulimit-4)
		chargemenu = true
		else
		chargemenu = false
	end
end

function creerMenu()
	dicot14:activate()
	for i = 1,table.getn(menu) do
		if posmenu == i then
		couleur = grisfonce
		else
		couleur = blanc
		end
		dicot14:print(10,20*i+30-20, couleur, menu[i])
	end
end



while pge.running() do

	pge.controls.update()
	pge.gfx.startdrawing()
	pge.gfx.clearscreen()
	
	
	if state == 0 then
		if categories then
			if article then
				------ ARTICLE ------
				
				if chargearticle then
					if pge.controls.pressed(PGE_CTRL_CIRCLE) then
						debuttelechargement = false
						telechargement = false
						fintelechargement = false
						debutinstallation = false
						installationencours = false
						fininstallation = false
						debutfinition = false
						finitionencours = false
						finfinition = false
						dejainstalle = false
						article = false
						chargearticle = false
						procinstall = false
					end
					if pge.controls.pressed(PGE_CTRL_START) then
						install()
					end

					
					fond:activate()
					fond:draweasy(0, 0)
					
					creerMenu()
					
					dicot14:activate()
					dicot14:print(120, 30, blanc, cat[poscat])
					
					imagearticle:activate()
					imagearticle:draweasy(120, 60)
					height = imagearticle:height() 
					
					dicot10:activate()
					dicot10:print(120, 45, blanc, "Dev: "..artdev[poscat].." - Note:"..artnote[poscat].."/20".." - "..artdate[poscat])
					dicot10:print(120, 65+height, blanc, arttexte[poscat])
	
					
					boutoninstall()
					if procinstall then
					pge.gfx.drawrect(0,0,480,272,noiralpha)
					end
					
					dicot10:activate()
					
					if finitionencours then
					creertxt(artpath[poscat],artid[poscat])
					end
					if debutfinition then
						fininstallation = false
						dicot10:printcenter(115, rouge, "Telechargement : OK")
						dicot10:printcenter(125, rouge, "Extraction ZIP : OK")
						dicot10:printcenter(135, rouge, "Installation : Veuillez Patientez......")
						finitionencours = true
					end
					if finfinition then
						dicot10:printcenter(115, rouge, "Telechargement : OK")
						dicot10:printcenter(125, rouge, "Extraction ZIP : OK")
						dicot10:printcenter(135, rouge, "Installation : OK")
						dejainstalle = true
						procinstall = false
					end
					
					if installationencours then
					installzip() 
					end
					if debutinstallation then
					fintelechargement = false
					dicot10:printcenter(115, rouge, "Telechargement : OK")
					dicot10:printcenter(125, rouge, "Extraction ZIP : Veuillez Patientez......")
					installationencours = true
					end
					if fininstallation then
					dicot10:printcenter(115, rouge, "Telechargement : OK")
					dicot10:printcenter(125, rouge, "Extraction ZIP : OK")
					debutfinition = true
					end
					
					if telechargement then
					loadzip(artlien[poscat])
					end
					if debuttelechargement then
					dicot10:printcenter(115, rouge, "Telechargement : Veuillez Patientez......")
					telechargement = true
					end
					if fintelechargement then
					dicot10:printcenter(115, rouge, "Telechargement : OK")
					dicot10:printcenter(125, rouge, "Extraction ZIP : Veuillez Patientez......")
					debutinstallation = true
					end
					
					
				else
					loadimgart(poscat)
				end
				
				
				------ FIN ARTICLE ------
			else
				------ RUBRIQUE ------
				
				fond:activate()
				fond:draweasy(0, 0)
				
				creerMenu()
				
				if chargecat then
				
					if pge.controls.pressed(PGE_CTRL_RIGHT) then
						if poscat < poscatlimit then
							poscat = poscat + 1
							else
							poscat = 1
						end
						
					end
					
					if pge.controls.pressed(PGE_CTRL_LEFT) then
						if poscat > 1 then
							poscat = poscat - 1
							else
							poscat = poscatlimit
						end
					end
					
					if pge.controls.pressed(PGE_CTRL_DOWN) then
						if poscat+4 <= poscatlimit then
							poscat = poscat + 4
						end
						
					end
					
					if pge.controls.pressed(PGE_CTRL_UP) then
						if poscat-4 >= 1 then
							poscat = poscat - 4
						end
					end
					
					if pge.controls.pressed(PGE_CTRL_CIRCLE) then
						poscat = 1
						categories = false
					end
					
					if pge.controls.pressed(PGE_CTRL_CROSS) then
						testdejainstalle(artpath[poscat])
						article = true
					end
					
					if pge.controls.pressed(PGE_CTRL_SQUARE) then
						exectri()
					end
					
					dicot14:activate()
					dicot14:print(120, 30, blanc, cat[poscat])
					
					cpt = 1
					cpt2 = 1
					for i=1,poscatlimit do
						if cpt > 4 then
							cpt = 1
							cpt2 = cpt2+1
						end
						
						posX = 91*cpt+120-91
						posY = 50*cpt2+50-50
						
						imgcat[i]:activate()
						imgcat[i]:draweasy(posX,posY)
						
						if i == poscat then
						pge.gfx.drawrectoutline(posX,posY, 72, 40, rouge)
						end
						
						cpt = cpt+1
					end
				
				else
					if menu[posmenu] == "Recherche" then
					envoi = recherche
					else
					envoi = posmenu
					end
					
					loadDataCat(envoi, tricat)
					loadimg(poscatlimit)
				end
				------ FIN RUBRIQUE ------
			end
			
		else
			
			------ MENU ------
			chargecat = false
			
			if chargemenu then
				
				if usbnonactive and recherchenonactive then
				if pge.controls.pressed(PGE_CTRL_DOWN) then
					if posmenu < posmenulimit then
						posmenu = posmenu + 1
						else
						posmenu = 1
					end
				end
				
				if pge.controls.pressed(PGE_CTRL_UP) then
					if posmenu > 1 then
						posmenu = posmenu - 1
						else
						posmenu = posmenulimit
					end
				end
				end
				
				if pge.controls.pressed(PGE_CTRL_CROSS) then
					if posmenu ~= 1 and posmenu <= posmenulimit-4 then
					categories = true
					end
					if menu[posmenu] == "USB" then
						pge.usb.activate()
						usbnonactive = false
					end
					if not recherchenonactive then
						recherche = recherche..alphabet[posalphabet]
					end
					if menu[posmenu] == "Recherche" then
						recherchenonactive = false
					end
					if menu[posmenu] == "Quitter" then
						pge.exit()
					end
				end
				
				
				fond:activate()
				fond:draweasy(0, 0)
				
				creerMenu()
				
				dicot14:activate()
				dicot14:print(120, 30, blanc, menu[posmenu])
				
				if posmenu <= posmenulimit-4 then
				imgmenu[posmenu]:activate()
				imgmenu[posmenu]:draweasy(120, 50)
				height = imgmenu[posmenu]:height() 
				else
				height = 0
				end
				
				texteaff = menudesc[posmenu]
				if menu[posmenu] == "USB" then
					if pge.usb.activated() then
					texteaff = "Connexion USB Active\nPressez Rond pour Desactiver"
					if pge.controls.pressed(PGE_CTRL_CIRCLE) then
						pge.usb.deactivate()
						usbnonactive = true
					end
					else
					texteaff = "Connexion USB Non Active\nPressez Croix pour Activer"
					end
				end
				if menu[posmenu] == "Recherche" and not recherchenonactive then
					dicot14:activate()
					cpt = 1
					cpt2 = 1
					for i=1, table.getn(alphabet) do
						if cpt > 10 then
								cpt = 1
								cpt2 = cpt2+1
						end
						
						
						if i == posalphabet then
						couleur = grisfonce
						else
						couleur = blanc
						end
							
						dicot14:print(30*cpt+120-30, 30*cpt2+150-30, couleur, alphabet[i])
						
						cpt = cpt+1
					end
					
					if pge.controls.pressed(PGE_CTRL_SQUARE) then
						recherche = string.sub(recherche,0, string.len(recherche)-1)
					end
					if pge.controls.pressed(PGE_CTRL_START) and recherche ~= "" then
						categories = true
					end
					
					if pge.controls.pressed(PGE_CTRL_CIRCLE) then
						recherchenonactive = true
						recherche = ""
					end
					
					if pge.controls.pressed(PGE_CTRL_RIGHT) then
						if posalphabet < table.getn(alphabet) then
							posalphabet = posalphabet + 1
							else
							posalphabet = 1
						end
						
					end
					
					if pge.controls.pressed(PGE_CTRL_LEFT) then
						if posalphabet > 1 then
							posalphabet = posalphabet - 1
							else
							posalphabet = table.getn(alphabet)
						end
					end
					
					if pge.controls.pressed(PGE_CTRL_DOWN) then
						if posalphabet+10 <= table.getn(alphabet) then
							posalphabet = posalphabet + 10
						end
						
					end
					
					if pge.controls.pressed(PGE_CTRL_UP) then
						if posalphabet-10 >= 1 then
							posalphabet = posalphabet - 10
						end
					end
					
					texteaff = "Module de Recherche"
					dicot14:print(120, 70, blanc, "Mot a chercher : "..recherche)
				end
				
				
				dicot10:activate()
				dicot10:print(120, 55+height, blanc, texteaff)
				
			else
				loadData(posmenu)
			end
			------ FIN MENU ------
		end
		
	end
	
	
	pge.gfx.enddrawing()
	
	------ CONNEXION ------
	if state ~= 0 then
		state = pge.utils.netupdate()
	end
	
	pge.gfx.swapbuffers()
	
end

pge.usb.shutdown()