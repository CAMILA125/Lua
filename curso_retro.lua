-- title:  bigodudo
-- author: camila   munzlinger
-- desc:   teste
-- script: lua,
ITEM_VIDA=208
ITEM_MOEDA=210
ITEM_POCAO=209
ITEM_PORTAL=212
ITEM_PORTAL2=213
ITEM_TARTARUGA=214
ITEM_DUG=215
ITEM_PINGUIN=216
ITEM_BONECO=217
p={
	x = 5,
	y = 100,
	vx = 0, -- velocidade do eixo x
	vy = 0, -- velocidade do eixo Y
	h = 11, --altura
	w = 9, --largura
	grounded = false, -- verifica se esta no chao
	atrito = 0.7, --atrito
	grav = 0.2, --gravidade
	velocity = 1, --velocidade
	max_vy = 2.5, -- velocidade de queda
	boost = 3, -- forca do pulo
	sprite1 =259, --superior esquerdo
	sprite2 =260, --superior direito
	sprite3 =275, --inferior esquerdo
	sprite4 =276, --infeiror direito
	flip=0, --dircao personagem
	vidas=3, --item para contar
	moedas=0,
	frame=0,
	aspeed=0, -- velocidade
	flash = 0, -- timer de invencibilidade
}

objetos={} --lista de objetos

stage = {
		mx1=0,
		my1=0,
		mx2=59,
		my2=16,
		num= 1,
}

camx = 0
camy = 0

function add_object(oid, px, py)
		local o = {
			id = oid,
			x = px,
			y = py,
			vx = 0,
			h = 8,
			w = 8,
			visible = true,
			alive= false,
			can_die = false,
			}
			if oid == ITEM_VIDA then
		   o.sprite=264
		  	o.frame=2
		  	o.aspeed=500
			end
			if oid == ITEM_MOEDA then
		  	o.sprite=304
		  	o.frame =4
		   o.aspeed=150
			end
			if oid == ITEM_PORTAL then
		  	o.sprite=285
		  	o.frame=1
			  o.aspeed=500
			end
			if oid == ITEM_PORTAL2 then
		  	o.sprite=269
		  	o.frame=1
			  o.aspeed=500
			end
			if oid == ITEM_POCAO then
		 	 o.sprite=280
			  o.frame=2
			  o.aspeed=750
			end
			if oid == ITEM_TARTARUGA then
		 	 o.sprite=369
			  o.frame=2
			  o.aspeed=750
					o.alive= true
					o.can_die = true
					o.vx = -0.2
			end
			if oid == ITEM_DUG then
		 	 o.sprite=385
			  o.frame=2
			  o.aspeed=300
					o.alive= true
			end
					if oid == ITEM_PINGUIN then
		 	 o.sprite=401
			  o.frame=2
			  o.aspeed=300	
					o.alive= true
					o.can_die = true
					o.vx = 0.2
			end
			if oid == ITEM_BONECO then
		 	 o.sprite=417
			  o.frame=2
			  o.aspeed=300
					o.alive= true
			end

			table.insert(objetos,o)
			
end


--troca de fase
function load_stage(s)
 p.moedas=0
 p.boost =3
	objects ={}
	stage.num = s

	if s ==1 then
			p.x=20
			p.y=20
			
			stage.mx1=0
			stage.my1=0
			stage.mx2=59
			stage.my2=16
	end
			
	if s ==2 then
			p.x=0
			p.y=192
			
			stage.mx1=0
			stage.my1=17
			stage.mx2=59
			stage.my2=33
	end
	if s ==3 then
			p.x=128
			p.y=344
			
			stage.mx1=0
			stage.my1=34
			stage.mx2=29
			stage.my2=50
	end
	
	
		-- varredura por objetos no mapa
		for mx = stage.mx1, stage.mx2 do
				for my =  stage.my1, stage.my2 do
						local id=0
						id=  mget(mx,my)
						if id >= 208 then 
								add_object(id, mx*8 , my*8)
								mset(mx,my, mget(mx,my-1))
						end
				end
		end
end

--funcao chamada no inicio do jogo
function init()
 load_stage(1)
end
function obj_colission(a,b) --colidir
		if a.x < b.x + b.w and
		   a.x + b.w - 1 >= b.x and
					a.y < b.y + b.h and
					a.y + a.h - 1>= b.y then
			return true
		else 
			return false
			
		end
		
end
function solid(px, py)  --objetos para colidir
		local mx = px // 8
		local my = py // 8
		local b = mget(mx, my)
		
		
		if mx<stage.mx1 or mx>stage.mx2 then
				return true 
		end
		if my<stage.my1 or my>stage.my2 then
				return false
		end
		if b == 1 or b == 2 or b == 3 or b == 4 or b == 5 or b == 6 or b == 7 or  b == 128 or b == 129 or b == 130 or b == 131 or b == 132 or b == 133 or b == 134 then 
				return true
		else 
				return false
		end
end

init()
function TIC()
		p.vx = p.vx * p.atrito -- atrito
		p.vy = p.vy + p.grav --gravidade
			if p.vidas >0 then
				if btn(2) then 	--2 seta para esquerda
							p.vx = -p.velocity
							p.flip= 1
							p.sprite1=260
							p.sprite2=259
							p.sprite3=276
							p.sprite4=275
				end
				if btn(3) then --3 seta para direita
							p.vx = p.velocity
							p.flip= 0
							p.sprite1=259
							p.sprite2=260
							p.sprite3=275
							p.sprite4=276
							
				end
				if btnp(0) and p.grounded then 	--0  seta para pulo
					p.vy = - p.boost
						sfx(6,"G-4")
				end
			end
			if p.vy> p.max_vy then
				p.vy= p.max_vy
			end
			local old_y = p.y
			p.y = p.y + p.vy
			--testa colisao para baixo
			if solid(p.x+3,p.y+p.h) or solid (p.x+p.w,p.y+p.h)then
				p.y = old_y
				p.vy=0
				p.grounded = true
			else
				p.grounded = false
			end
			--testa colisao para cima
			if solid(p.x+3,p.y+1) or solid (p.x+p.w,p.y+1)then
					p.y = old_y
					p.vy=0
			end
			local old_x = p.x
			p.x = p.x + p.vx
			--testa colisao para a direita
			if solid(p.x+p.w,p.y) or solid(p.x+p.w,p.y) or solid(p.x+p.w,p.y+p.h)or solid(p.x+p.w,p.y+p.h-6) then
					p.x = old_x
					p.vx = 0
			end
			--testa colisao para a esquerda
			if solid(p.x+3,p.y+1)or solid(p.x+3,p.y+p.h) or solid(p.x+3,p.y+p.h-6) then
					p.x = old_x
					p.vx = 0
			end
			
			
			if p.y > stage.my2 * 8 then
						p.vidas=0
			end
			--	sfx(1,"c-4")
	
			--x, y, largura, altura, cor
			--rect(x ,y ,10,10,6)
			--testa colisao como os objetos
		for i=1, #objetos do
			local o = objetos[i]
				if o.visible then
					if obj_colission(p,o) then
							if o.id== ITEM_VIDA then
					 				 o.visible= false 
											p.vidas= p.vidas+1
											sfx(5,"b-4")
							end
							if o.id== ITEM_MOEDA then
					 				 o.visible= false 
											p.moedas= p.moedas+1
											sfx(4,"b-8")
							end
								if o.id== ITEM_POCAO then
					 				 o.visible= false 
											p.boost= 5
											sfx(2,"g-4")
							end
								if o.id==ITEM_PORTAL or  o.id==ITEM_PORTAL2  then
										if p.moedas>=2 then
									   
													sfx(3,"e-5")
													load_stage(stage.num + 1)
													return 
										end
								end
								
								if o.alive then
										if p.flash < time() then
												if o.can_die and not p.groudend and p.vy >0 then
										  	 o.sprite = o.sprite -1
													 o.frame = 1
														o.alive = false
														p.vy = -p.boost
														sfx(3,"b-4")
													
												else
															p.vidas = p.vidas -1
															p.flash = time() +1000
															sfx(7,"c-3")
															p.vx = -p.vx*2
												end
										end
								end
								
						end
					end
		end
		 
		for i=1, #objetos do 
	    local o = objetos[i]
					if o.visible and o.alive then
								old_x = o.x
								o.x = o.x + o.vx
								
								if solid(o.x+o.w-1, o.y) or
									 	solid(o.x+o.w-1, o.y+o.h-1)or
									 	solid(o.x,o.y) or
											solid(o.x,o.y+o.h-1) or
											solid(o.x+o.w/2.0,o.y+o.h) and
											(not solid(o.x-1,o.y+o.h) or not(solid(o.x+o.w,o.y+o.h))) then
											
												o.x = old_x
												o.vx = o.vx* (-1)
					   end
					end
		end
		
		
		
		--gerencia as animacoes do protagonista
		if p.flip == 0 then
			 	p.sprite1 =259
				 p.sprite2 =260
				 p.sprite3 =275
				 p.sprite4 =276
				 p.frame=1
				 p.aspeed = 300
			else
					p.sprite1 =260
			 	p.sprite2 =259 
			 	p.sprite3 =276
		 		p.sprite4 =275
			 	p.frame=1
				 p.aspeed = 300
			end
			
		--andando
		if p.grounded and (btn(2) or btn(3)) then
			if p.flip == 0 then
			 	p.sprite1 =261
				 p.sprite2 =262
				 p.sprite3 =277
				 p.sprite4 =278
				 p.frame=1
				 p.aspeed = 300
			else
					p.sprite1 =262
			 	p.sprite2 =261 
			 	p.sprite3 =278
		 		p.sprite4 =277
			 	p.frame=1
				 p.aspeed = 300
			end
		
		end
		
		--pulando
		if not p.grounded and p.vy < 0.0 then
			 if p.flip ==0 then
					p.sprite1 =452
				 p.sprite2 =453
				 p.sprite3 =468
				 p.sprite4 =469
				 p.frame=1
					p.aspeed = 1
					else
					p.sprite1 =453
				 p.sprite2 =452
				 p.sprite3 =469
				 p.sprite4 =468
				 p.frame=1
					p.aspeed = 1
					end
		end
		
		--caindo 
	if not p.grounded and p.vy>= 0.2 then
				 if p.flip ==0 then
					p.sprite1 =448
				 p.sprite2 =449
				 p.sprite3 =464
				 p.sprite4 =465
				 p.frame=1
					p.aspeed = 1
					else
					p.sprite1 =449
				 p.sprite2 =448
				 p.sprite3 =465
				 p.sprite4 =464
				 p.frame=1
					p.aspeed = 1
					end
	end
	--morto
	if p.vidas<= 0 then
			if p.flip == 0 then
					p.sprite1 = 450
					p.sprite2 = 451
					p.sprite3 = 466
					p.sprite4 = 467
					p.frame = 1
				else
					p.sprite1 = 451
					p.sprite2 = 450
					p.sprite3 = 467
					p.sprite4 = 466
					p.frame = 1
				end
	end
		
			cls(13)
			--calculo da camera
			camx = p.x - 120
			camy = p.y - 68
			
			camx = math.min(math.max(camx,stage.mx1*8),(stage.mx2-29)*8)
   camy = math.min(math.max(camy,stage.my1*8),(stage.my2-16)*8)		
			map(camx//8,camy//8,31,18, -(camx%8), - (camy%8))
			--desenha objetos
			for i=1, #objetos do 
						local o = objetos[i]
						if o.visible then
								spr(o.sprite+(time()//o.aspeed)%o.frame,o.x-camx,o.y-camy,0)
						end
			end
			
			
			--id do sprite, x, y, cor de trasnparencia
			if p.flash <= time() or (time()//100)%2 then	
				spr (p.sprite1+(time()//p.aspeed)%p.frame,p.x-camx,p.y-camy,1,1, p.flip)
				spr (p.sprite2+(time()//p.aspeed)%p.frame,p.x+8-camx,p.y-camy,1,1, p.flip)
				spr (p.sprite3+(time()//p.aspeed)%p.frame,p.x-camx,p.y+8-camy,1,1, p.flip)
				spr (p.sprite4+(time()//p.aspeed)%p.frame,p.x+8-camx,p.y+8-camy,1,1, p.flip)
			end
			print("vida "..p.vidas,195,0)
			print("moedas "..p.moedas,195,8)
			
			if p.vidas <=0 then
						print("-GAME OVER-",90,60)
			end
end
