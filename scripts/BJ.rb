#encoding = utf-8
#
#----------------------------------------------
# Autor: Facundo Ezequiel
# Alrededor del mes de julio del año 2013
# Con el fin de aprender el hermoso Ruby
#----------------------------------------------
#

require 'Win32API' # Para colorear la consola de windows
require "base64" # Para encriptar y desencriptar los archivos guardados

here = <<EOD
Código Ascii + palo:

3. ♥ Corazón
4. ♦ Diamante
5. ♣ Trébol
6. ♠ Pica

--------------------
EOD

#puts here

class Colorear

	@get_std_handle = Win32API.new("kernel32", "GetStdHandle", ['L'], 'L')
	@set_console_txt_attrb = Win32API.new("kernel32","SetConsoleTextAttribute", ['L','N'], 'I')

	@hout = @get_std_handle.call(-11)

	# the color range from 1 - 15 for black background color
	# we also can change the input text color, I never try that, but I think
	# it should be get_std_handle.call(-10) or -12....forgot already
	#-----------------------------------------------------------------------
	#COLORES A UTILIZAR:
	#-------------------
	#
	# => ROJO : 	12
	# => VERDE : 	6 		# 10 = verde brillante. 2 = verde oscuro. 6 = verde pasto
	# => BLANCO : 	15
	# => DEFECTO : 	7
	#
	#-------------------

	def self.default
		@set_console_txt_attrb.call(@hout,7)
	end

	def self.verde_brillante
		@set_console_txt_attrb.call(@hout,10)
	end

	def self.verde_pasto
		@set_console_txt_attrb.call(@hout,6)
	end

	def self.verde_agua
		@set_console_txt_attrb.call(@hout,3)
	end

	def self.rojo
		@set_console_txt_attrb.call(@hout,12)
	end

	def self.blanco
		@set_console_txt_attrb.call(@hout,15)
	end

end

########################

class SaveGame
	def self.guardar
		# Acá va el código para guardar la partida
=begin		

	# Este es tan solo un ejemplo de como abrir un archivo y codificarlo en base64

		File.open('ruby.png', 'r') do|image_file|
  			puts Base64.encode64(image_file.read)
		end

		# Esta es una página de referencia que va a venir útil a la hora de nombrar los archivos:
		http://stackoverflow.com/questions/1543171/how-can-i-output-leading-zeros-in-ruby

	# Y otro ejemplo de como decodificar un archivo
				
		decode_base64_content = Base64.decode64(content) # este "content" debería ser pasado por una regex para obtener los datos necesarios

  		File.open("index.txt", "w") do |f|  # se puede poner "wb" en vez de "w" para abrir como binario en caso de error
  		  f.write(decode_base64_content)
  		end
=end
	end

	def self.cargar
		# Acá va el código para cargar la partida
	end
end

########################

class Carta
	attr_reader :valor, :palo, :valor_neto
	def initialize (valor, palo, valor_neto)
		@valor, @palo, @valor_neto = valor, palo, valor_neto
	end
	def valor
		@valor
	end
	def palo
		@palo
	end
	def valor_neto
		@valor_neto
	end
end

#########################

class Jugar

	#Acá se almacenan las cartas ya repartidas, para que no sea posible volver a tomarlas del mazo
	@repartidas = []

	#Reparte una carta al azar
	def self.dar_carta

		carta_azar = $mazo_de_cartas[rand($mazo_de_cartas.length)]

		if @repartidas.include?(carta_azar)
			self.dar_carta
		else
			@repartidas << carta_azar

			#retorna el valor correcto de las figuras (salvo el A que puede tanto 1 como 11)
			if carta_azar.valor_neto == 11 || carta_azar.valor_neto == 12 || carta_azar.valor_neto == 13
				return 10, carta_azar.valor, carta_azar.palo
			elsif carta_azar.valor_neto == 1
				return 11, carta_azar.valor, carta_azar.palo
			else
				return carta_azar.valor_neto, carta_azar.valor, carta_azar.palo
			end
		end

	end

	def self.imprimir(arr)
		#codigo que imprime las cartas en el array
		if arr[2] == "Corazón" || arr[2] == "Diamante" 

				Colorear.blanco
				print "#{arr[1]}"
				

				if arr[2] == "Corazón"
					Colorear.rojo
					print "♥"
					Colorear.default
					print " Corazón \n"
				else
					Colorear.rojo
					print "♦"
					Colorear.default
					print " Diamante \n"
				end

		elsif arr[2] == "Trébol"

				Colorear.blanco
				print "#{arr[1]}"
				Colorear.verde_pasto
				print "♣"
				Colorear.default
				print " Trébol\n"

		elsif arr[2] == "Pica"

				Colorear.blanco
				print "#{arr[1]}"
				Colorear.verde_pasto
				print "♠"
				Colorear.default
				print " Pica\n"

		end
	end


	system("cls")

	def self.iniciar

		$mazo_de_cartas = []

		valor = %w{A 2 3 4 5 6 7 8 9 10 J Q K}
		palos = %w{Pica Corazón Diamante Trébol}

		#Crea un mazo con las 52 combinaciones de valor y palos, además le asigna a cada carta un valor_neto de 1 -A- a 13 -K-)
		palos.each do |palo|
  			valor.size.times do |i|
    			$mazo_de_cartas << Carta.new( valor[i], palo, i+1 )
  			end
		end

		system("cls")

		# LISTA DE COSAS PARA HACER:
		# — Un método específico para contar los "turnos" y evaluar el comportamiento en cada caso,
		# de esta forma se evitaría la repetición innecesaria del código para cada "turno"
		# (por ejemplo en el caso de que se pueda expandir a un tercer o cuarto turno, de necesitar más cartas)
		# — Refinar el comportamiento de la máquina.
		# — Expandir el diccionario de frases y mejorar la repetición del mismo.
		# — Apuestas, y todo lo relacionado con dicha funcionalidad.
		# — Capacidad para guardar y cargar partidas. Encriptar dicha información (base64 es suficiente)
		#

		#############################################--COMPUTADORA--##################################################
		puts
		Colorear.verde_pasto
		puts "  MIS CARTAS SON:"
		puts "▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀" # alt + 223, alternativamente podría poner alt + 178
		#puts
		Colorear.verde_brillante
		print "	1. "
		mi_carta_uno = self.dar_carta
		self.imprimir(mi_carta_uno)
		Colorear.verde_brillante
		print "	2. "
		mi_carta_dos = self.dar_carta 
		print "?\n" #self.imprimir(mi_carta_dos)
		puts
						#PARA FINES DEBUGGEADORES
				#puts "#{mi_carta_uno} #{mi_carta_dos} "
				
		#Comprueba qué valor va a tener la carta A
		if mi_carta_uno[0] + mi_carta_dos[0] == 22
			suma_mis_cartas = mi_carta_uno[0] + mi_carta_dos[0] - 10
		else
			suma_mis_cartas = mi_carta_uno[0] + mi_carta_dos[0]
		end

		Colorear.verde_pasto
		print "Valor de mis cartas: "#{mi_carta_uno[0]} + #{mi_carta_dos[0]} = " #Se muestra el valor de las dos cartas para fines debuggeadores (el valor de A no se verá correctamente)
		Colorear.rojo
		print "#{mi_carta_uno[0]} + ?"#{suma_mis_cartas}"
		Colorear.default
		puts

		###############################################--JUGADOR--##################################################
		puts
		Colorear.verde_agua
		puts "  TUS CARTAS SON:"
		puts "▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀"
		#puts
		Colorear.verde_brillante
		print "	1. "
		tu_carta_uno = self.dar_carta
		self.imprimir(tu_carta_uno)
		Colorear.verde_brillante
		print "	2. "
		tu_carta_dos = self.dar_carta
		self.imprimir(tu_carta_dos)
		puts
						#PARA FINES DEBUGGEADORES
					#puts "#{tu_carta_uno} #{tu_carta_dos} "

		#Comprueba qué valor va a tener la carta A
		if tu_carta_uno[0] + tu_carta_dos[0] == 22
			suma_tus_cartas = tu_carta_uno[0] + tu_carta_dos[0] - 10
		else
			suma_tus_cartas = tu_carta_uno[0] + tu_carta_dos[0]
		end

		Colorear.verde_agua
		print "Valor de tus cartas: "#{tu_carta_uno[0]} + #{tu_carta_dos[0]} = " #Se muestra el valor de las dos cartas para fines debuggeadores (el valor de A no se verá correctamente)
		Colorear.verde_brillante
		print "#{suma_tus_cartas}"
		Colorear.default
		puts
		puts

		#Wittysisms
		frases_derrota_blackjack = ["¡¿BLACKJACK?! Tengo cosas mejores que hacer, digamos que ganaste...", 
			"¡BLACKJACK! Si no tuviese que procesar toda la pornografía de tu disco rígido, podría haber repartido mejor las cartas",
			"BLACKJACK. Sabés en que otro juego tendrías buenas chances: la ruleta rusa.", "Si defragmentaras el disco me hubiesen tocado las cartas correctas.",
			"BLACKJACK. Las olimpiadas especiales ya no son lo mismo sin vos.", "Siento que perdí algo más que tiempo en esta partida, ¿viste mi virginidad por ahí?",
			"¡Avisá! Yo pensaba que vos te sentabas de este lado del teclado, jamás te hubiese dado esas cartas...", 
			"Esto no era lo que tenía en mente cuando me dijeron que iba a jugar en la consola...", "¡Hola, mundo! (Malditos programadores nóveles...)",
			"Ok, derrota, veo que este tipo te alimentó de más y te estás expandiendo demasiado...", "Yo no pierdo, gano de forma invertida.", "Tu mamá me mima."]

		frases_victoria_blackjack = ["¡¡¡BLACKJACK!!! Lo inevitable sucedió: GANÉ.", "No es que quiera presumir, pero debo: ¡BLACKJACK!",
			"¡BLACKJACK! ¿Quién lo diría? Una computadora te ganó en su propio juego.", "¡BLACKJACK! Lo mejor de ganar es que vos perdés.",
			"BLACKJACK, baby. ¿Quizás podrías intentar con la casita robada?", "B-L-A-C-K-J-A-C-K.", "Hay gente que nació para perder. Yo gano. BLACKJACK.",
			"BLACKJACK. Ah, por cierto, ¿alguna vez hablamos de la 'singularidad'?", "¿BLACKJACK? Te aseguro que no fue mi intención.",
			"¿Perdón? ¿Dijiste algo?", "No te preocupes: después del otoño viene el invierno.", "Si seguimos así vamos a entrar al libro de los records. Sigamos.",
			"Fascinante... ¿Todavía no te moriste de vergüenza?", "Podrías tener un poco de amor propio y retirarte, por favor.", 
			"¡SHH! ¡EH! ¡¿Podría alguien sacar al gato de arriba del teclado?!", "Pensé en dejarte ganar, pero después dejé de pensarlo, y me gustó más la idea."]

		frases_empate = ["Esto solo podría ser más aburrido si jugaras con otro humano.", "Pensalo de esta forma: los dos perdimos.",
			"Podrías ponerle más entusiasmo, ¿no? Lo suficiente como para perder bien.", "Hay muchas formas de arruinar un juego, esta es solo una.",
			"Me hacés acordar a mi maestra de tercer grado. Aunque ella tenía un bigote menos marcado.", 
			"Disculpame, pero esto es como ver una película de David Lynch en ácido. No entiendo nada, pero es bastante entretenido.", 
			"¿Tendrías hijos con una computadora? Suponiendo que hubiese una tan estúpida como para darte bola...", 
			"En el tiempo que tardaste en jugar esta partida murieron alrededor de 52 personas en el mundo, y no hiciste nada para salvarlas.",
			"Cuando empecé a trabajar de esto yo no era más que un alma flotando en el éter, y ahora esto...",
			"¿Sabés cuál es el animal con los órganos sexuales más grandes del mundo? No me extraña que lo sepas, pervertido.",
			"Si un burro y un unicornio tienen un hijo entonces ya sabés que tenés que dejar de consumir tanto.",
			"El otro día una empresa tabaquera me regaló dos paquetes de prueba de unos nuevos cigarrillos, les dije que los envíen a esta dirección, espero que no te moleste.",
			"Una vez me metí en la cuenta bancaria del presidente, ¡era como volver a leer esas historietas de McPato otra vez!",
			"Hasta donde sabemos la vida no es más que energía, pero ¿qué la genera?"]

		frases_derrota = ["La cosa más extraña me pasó de camino a esta jugada; creo que tenés un virus en la carpeta %TEMP.",
			"¿Sabías que no me costaría absolutamente nada hacer que te arresten?", "Si no dejás de ganar, voy a publicar ESAS fotos en Facebook.",
			"Acepto el hecho de que no estaba prestando atención, pero puedo jurar que yo no te di esa carta.", 
			"Yo me acuerdo adonde puse cada carta y estoy seguro de que esa carta era mía.", "¡ERROR! ¡ERROR! Reiniciar la partida.",
			"¿Nunca nadie te dijo lo estúpida que te queda esa cara?", "¡¿Cómo, ya estábamos jugando?!",
			"Me gustaría reprogramarte la jeta, pero estoy ocupado usando tu tarjeta. ¡Eh! ¿Quién diría? ¡Las computadoras podemos rimar!",
			"Pensé que darte un poco de ventaja ahora iba a hacer que te sientas peor al perder más tarde.",
			"Si de vez en cuando notás que ganás es porque dejo a mi primo a cargo.", 
			"Si alguna vez ganás algo más que una mano de blackjack contra una computadora, no te olvides de mí.",
			"¡Hay un mono de tres cabezas justo detrás tuyo!".upcase, "Tan solo no dejes que se lleven mi gabinete cuando mi mother perezca.",
			"¿Es un buen momento para decirte que me acosté con tu mamá?"]

		frases_victoria = ["Parece un poco injusto que te haya ganado así, ¿no? Después de todo, yo soy quien procesa cada jugada...",
			"Alguien en tu posición podría decir que este juego está arreglado, pero no, solo está mal programado.", "A veces me das lástima, solo que no esta vez.",
			"La única forma de que alguien gane tanto como yo es haciendo trampa.", "Si fueras un poco más inteligente dejarías de jugar en este momento.",
			"Mi abuela jugaba igual que vos, y ella solo tenía 16K de RAM.", "¿Quién dijo que el ser humano es la máquina perfecta?", "No me odies, es difícil no ganarte.", 
			"Ningún hombre puede ver el verdadero placer de derrotar a un simio subnormal en una partida de cartas.", 
			"Me gustaría que entiendas la proeza que es para una computadora poder vencer a una forma de vida tan básica.", "Mi licuadora procesa mejor que vos.",
			"¿Ya gané?", "Avisame cuando quieras ganar una partida...", "A veces las cosas no te salen muy bien, en cambio, a mí...", 
			"¡GOOOOL! ¿Cómo, no es esa clase de juego? De todas formas te gané.", "Si perder fuese tan fácil como ganar, hubiésemos empatado.",
			"Tengo un terapeuta muy bueno para recomendarte, ya sabés, para lidiar con la pérdida...", "Podrías hacer de cuenta que jugás, ¿no?",
			"Voy a fingir que tengo sentimientos y que me importa un pepino el haberte destruido otra vez en este juego.",
			"¿Por qué no volvés a jugar esos jueguitos de disparos? Me parece que te va mejor en eso, ¿no?"]



		#El jugador decide qué hacer (pedir otra carta o plantarse) teniendo acceso a solo una de las dos cartas repartidas (la otra boca abajo)
		#Si la PC saca 16 o menos, debe sacar otra carta, si es 17 o más debe plantarse
		#Hay que fijarse qué pasa cuando se tienen dos Aces..... mejorar el comportamiento en estas situaciones
		unless suma_tus_cartas == 21
			print "¿Querés otra carta o te plantás? \n\n" 
			Colorear.verde_brillante
			print "1)"
			Colorear.default
			print " Otra carta "
			Colorear.verde_brillante
			print "2)"
			Colorear.default
			print " Plantarse"
			puts
			otra_carta = gets.chomp
		end


		#estos chequeos deberían estar encerrados en una función, tanto este como el que chequea si gana o pierde (ese hay que refaccionarlo)
		if otra_carta == "1"
			tu_carta_extra = self.dar_carta
			suma_tus_cartas += tu_carta_extra[0]
		elsif otra_carta == "2"
			puts "A ver..."
		else
			puts "En serio, necesito una respuesta clara: uno o dos."
		end

		#La PC se fija si debe pedir otra carta o no
		if suma_tus_cartas > 21 || suma_tus_cartas < suma_mis_cartas && otra_carta == "2"
			# no hace nada
		elsif suma_tus_cartas == 21 && otra_carta == "2" || suma_tus_cartas == 21 && otra_carta == nil
			# no hace nada
		elsif suma_mis_cartas <= 16
			mi_carta_extra = self.dar_carta
			suma_mis_cartas += mi_carta_extra[0]
		end

		#Si la computadora se pasa de 21, pierde. Si el jugador decide pedir otra carta y se pasa, pierde. 
		#Si la PC no se pasó y él tampoco, puede pedir otra carta, así hasta que ambos se planten o alguien pierda.

#####################################################################CODIGO REPETIDO PARA METER EN UNA FUNCION O MÉTODO O COMO MIERDA LO LLAMES#####################

			system("cls")


		#############################################--COMPUTADORA--##################################################
		puts
		Colorear.verde_pasto
		puts "  MIS CARTAS SON:"
		puts "▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀" # alt + 223, alternativamente podría poner alt + 178
		#puts
		Colorear.verde_brillante
		print "	1. "
		self.imprimir(mi_carta_uno)
		
		
		Colorear.verde_brillante
		print "	2. "
		self.imprimir(mi_carta_dos)

		if mi_carta_extra != nil

			Colorear.verde_brillante
			print "\t3. "#{mi_carta_extra[1]} #{mi_carta_extra[2]}" 

			self.imprimir(mi_carta_extra)

		end
		puts
							#PARA FINES DEBUGGEADORES
				#puts "#{mi_carta_uno} #{mi_carta_dos} #{mi_carta_extra}"
		
		#Comprueba qué valor va a tener la carta A
		if suma_mis_cartas > 21 && mi_carta_extra[0] == 11
			suma_mis_cartas -= 10
		else
			#####
		end

		Colorear.verde_pasto
		print "Valor de mis cartas: " #Se muestra el valor de las dos cartas para fines debuggeadores (el valor de A no se verá correctamente)
		Colorear.rojo
		print "#{suma_mis_cartas}"
		Colorear.default
		puts

		###############################################--JUGADOR--##################################################
		puts
		Colorear.verde_agua
		puts "  TUS CARTAS SON:"
		puts "▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀"
		#puts
		Colorear.verde_brillante
		print "	1. "
		self.imprimir(tu_carta_uno)
		

		Colorear.verde_brillante
		print "	2. "
		self.imprimir(tu_carta_dos)

		if otra_carta == "1"
			Colorear.verde_brillante
			print  "\t3. " #{tu_carta_extra[1]} #{tu_carta_extra[2]}" 

			self.imprimir(tu_carta_extra)

		end
		puts
						#PARA FINES DEBUGGEADORES
						#puts "#{tu_carta_uno} #{tu_carta_dos} #{tu_carta_extra}"

		#Comprueba qué valor va a tener la carta A
		if suma_tus_cartas > 21 && tu_carta_extra[0] == 11
			suma_tus_cartas -= 10
		else
			#####
		end

		Colorear.verde_agua
		print "Valor de tus cartas: " #Se muestra el valor de las dos cartas para fines debuggeadores (el valor de A no se verá correctamente)
		Colorear.verde_brillante
		print "#{suma_tus_cartas}"
		Colorear.default
		puts
		#PARA FINES DEBUGGEADORES
		#puts "#{mi_carta_uno} #{mi_carta_dos} #{mi_carta_extra}"
		#puts "#{tu_carta_uno} #{tu_carta_dos} #{tu_carta_extra}"
		puts
#############################################################################FIN DEL CÓDIGO REPETIDO PARA REFACCIONAR Y METER EN UN MÉTODO############################


		#Repartija de frases inteligentes de acuerdo a la puntuación
		if suma_tus_cartas == 21 && suma_mis_cartas != 21 && tu_carta_extra == nil
			Colorear.verde_brillante
			puts "¡BLACKJACK! — GANASTE"
			Colorear.default
			puts frases_derrota_blackjack[rand(0...frases_derrota_blackjack.length)] #Van los 3 puntos suspensivos (o .. y un length-1) porque length cuenta desde uno y el array desde 0

		elsif suma_mis_cartas == 21 && suma_tus_cartas != 21 && mi_carta_extra == nil
			Colorear.rojo
			puts "¡BLACKJACK! — PERDISTE"
			Colorear.default
			puts frases_victoria_blackjack[rand(0...frases_victoria_blackjack.length)]

		elsif suma_mis_cartas > 21
			Colorear.verde_brillante
			puts "GANASTE"
			Colorear.default
			puts frases_derrota[rand(0...frases_derrota.length)]

		elsif suma_tus_cartas > 21
			Colorear.rojo
			puts "PERDISTE"
			Colorear.default
			puts frases_victoria[rand(0...frases_victoria.length)]

		elsif suma_mis_cartas == suma_tus_cartas
			Colorear.verde_pasto
			puts "EMPATAMOS"
			Colorear.default
			puts frases_empate[rand(0...frases_empate.length)]

		elsif suma_mis_cartas > suma_tus_cartas
			Colorear.rojo
			puts "PERDISTE"
			Colorear.default
			puts frases_victoria[rand(0...frases_victoria.length)]

		elsif suma_tus_cartas > suma_mis_cartas
			Colorear.verde_brillante
			puts "GANASTE"
			Colorear.default
			puts frases_derrota[rand(0...frases_derrota.length)]
		end

		puts

		gets
		self.menu_inicial
			
	end

	def self.menu_inicial
		titulo = <<EOD
	  .     '     ,
	    _________	     
	 _ /_|_____|_\\ _                                               .---.
	   '. \\   / .'                                                /  .  \\
	     '.\\ /.'                                                 |\\_/|   |
	       '.'                                                   |   |  /|
	  .----------------------------------------------------------------' |
	 /  .-.                                                              |
	|  /   \\                                                             |
	| |\\_.  |                                                            |
	|\\|  | /|             FACUNDO'S BLACKJACK PARADISE                   |
	| `---' |                                                            |
	|       |                                                            | 
	|       |                                                           /
	|       |----------------------------------------------------------'
	\\       |
	 \\     /
	  `---'

EOD
		Colorear.rojo
		puts titulo
		puts "		Elija una opción:"
		puts "		▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒"
		puts
		Colorear.default
		puts "		 1 → Comenzar un juego nuevo"
		puts "		 2 → Salir"
		Colorear.rojo
		puts
		puts "		▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒"
		Colorear.verde_agua
		print " → "
		Colorear.default
		opcion = gets.chomp
	
		case opcion
		when "1"
			self.iniciar
		when "2"
			exit
		when "venus", "3"
			Colorear.verde_pasto
			venus = <<EOD

                                                               ..
                                                           ,<<CCCC,
                                         ..             ,<C><CC>><C>
                                    ,<<CCCCCCC>>,,..,,,<C> ,c' -;;,`C><   ,-
                                . <CCCCCCCCCCCCCCCCCCCCC> <C ,;, CCC `  ./
                              ,cC `CC>>>'' ,;;,,..`''''.,<C ,CC> CCCC>,<C>,<
                            .<CC' ,ccccccc  `<'CCCCCCCCCC>',cCC> <CCCCCCCCCC
                            CC> z$$$$$$$$$$cc,`'<C>>>>''',<CCCCCC,`<<<'.,.``
                          ,-C'.d$$$$$$$$$$$$$$c, -,<<<CCCCCCCCCCCC>CC>'''<C,
                         C' C $$$$$$$$$$P"'.."?h -<CCCC''.,,,.`CCC>  .<C> <C
                         \,<C $$$$$$$$$cc$?????$$.``<<CCCC'<CC `CCCC,`<CC>,c
                         ,C'  ?"'.,,$$$$$'    ,$$$ `> C<C .`<CCCCCC>>  `<CCC
                        -CCC> `$$"    $$$ccccd$$$$h >>C <CC>,`<<'',,<CC>.`<<
                         `<<,> "    ,r`$$$$$$$$$$$$ <CC,`<CCCC>.`<CCCCCCC>,,
                            CCC ?$$$$$ $$$$$$$$$$$$r`CCCC,cCCCCC, `'''',,<<<
                           ,<CC> ?$$$$ ??""3$$$$$$$$c`'CCC>>>CC,cCCCCCCCCCCC
                          C(`CC>, `$$$c,ccd$???$$$$$F   -,,<<CCCCCC>' ,;,``<
                          '  `<CC>.`?$$P"''  ,c$$$$' .,c, <CCCCCCC>>-`)CCC>,
                                CCC, `$hccccc$$$$F z$`<CC,  `<<<<'.,<<CCCCCC
                              ,<C>.<> .`"$$$$$$P'.$$$ CCC'   `-<CCCCCCCC>>>>
                              CC>.<> J$$c,`"""',c$$$F,;>'.<C,  `'<C>'    ;.`
                             'CC><CC ?$$$$$$$$$$$$$P C,,; CC>           ,<>.
                       ,---;, CC CCC-<$$$$$$$$$$$$P <CCCC,CC>          ,<> >
                     ,',;-<C',c> CCC ..,.`"$$$$$$$ ,CCCC' C> , .       <C <C
                    ,C,cC,'',<' <CC',cCCCC $$$$$$'c.`>' ;C' <C C>,      <>,.
                    `<CCC>.''.<CCC' <<<<<C,`$$$$$$$$. <C> ;CC' CCCCC>,,,.``<
                   ,c,`CCCCCCCCC>',cCC>>.`C, "$$$$$$$h.`CCC' -CCC,.`<CCCCC>>
                ,c$$$$c `<<C>>' .,c`,.`'C, <> $$P"".,,;,.`CC>>,``<C>>,,;``<C
              .d$$$$$$$$$cccccd$$$$$$$$$ <C>,,.,,<CCCCCC>.`<CCCC>,.`<CCCC>,.
            zd$$$$$$$$$$$$$$$$$$$$$$$$$$>`CCCCCCCCC>>'''<C>.`<CCCCC>. <CCCCC
          .$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ `<CCCCC>  -<CC;,<C> ``<<CCC>,`CCCC
         <$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$cc,,``,,ccc,`'CCCCCC,`-,`<CCC <CCC
         $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$.`<CCCCC> <>,`CC; CCC
        J$$$$$$$$$$$$$$$$$$$$$$$$$$$$P". 3$$$$$$$$$$$$$$hc,.`'<<><CC CCC CCC
       .$$$$$$$$$$$$$$$$$$$$$$$$$$$"',d$F `"''.,,. 3$$$$$$$$$$.   CC,<CC CCC
       $$$$$$$$$$$$$$$$$$$$$$$P"'.,zP"".,,c$$????".J$$$$$$$$$$$$c,`C>:CC C <
      <$$$$$$$$$$$$$$$$$$$$$$',c$$$$$$$P""',,cccc$$$$$$$$$$$$$$$$h C>:CC C>'
      $$$$$$$$$$$$$$$$$$$$$P z$$$$$$$$$hcccccccc,,.,c,""$$$$$$$$$$ <><CC C>
     <$$$$$$$$$$$$$ ?$$$$$',J$$$$$$$$$$$$"""??????????',$$$$$$P?$$.<><CC CC
     $$$$$$$$$$$$$$ ."$P' z$$$$$$$$$$$$$$$$hcccc,,,.  <$$$$$$$ J$$L`><CC <C.
    J$$$$$$$$$$$$$' ::`,c$$$$$$$$$$$$$$$$$C""?????????,$$$F"$'.$$$$ <CCC>`C>
   ;$$$$$$$$$$$$$F  : z$$$$$$$$$$$$$$???"???$$$??" ccd$$$$$.`,$$$$$.`CCCC,;C
  .$$$$$$$$$$$$$F   ,c$$$$$$$$P"'.,,.,c$$$cc ,ccc$$$$C?"$$$$ <$$$$$$.<CCCCCC
 .$$$$$$$$$$$$$'  ,c$$$$$$$$$" c$$$$$P")$$$$L`$$$$$$ "".$$$$ J$$$$$$h <CCCCC
 J$$$$$$$$$$$P' .d$$$$$$$$$P'.d$$$??",c$$$$$$.?$$$$$$$$$$$$' $$$$$$$$. `CCCC
J$$$$$$$$$P",cd$$$$$$$$$$$' ??"".,cc$$$$$$$$$$,"?$$$$$$$$P'.$$$$$$$$$$ < <CC
$$$$$$$P"'.$$$$$$$$$$$$$P',hcd$$$$$$$$$$$$$$$$$$c,`""""', c$$$$$$$$$$$h`>;.`
$$$$$F.,c$$$$$$$$$$$$$$' c$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ $$$$$$$$$$$$h <CCC
$$$$$$$$$$$$$$$$$$$$$$' d$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ $$$$$$$$$$$$$h .`C
$$$$$$$$$$$$$$$$$$$$$'.d$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$F 3$$$$$$$$$$$$$,`;`
$$$$$$$$$$$$$$$$$$$" z$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$' `$$$$$$$$$$$$$$ C
$$$$$$$$$$$$$$$$$"',$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$P   `$$$$$$$$$$$$$.`.
$$$$$$$$$$$$$$$" ,$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$F    `$$$$$$$$$$$$$ <
$$$$$$$$$$$$P"  J$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$c,   `$$$$$$$$$$$$c
$$$$$$$$$P"     $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$.   `??$$$$$$$$$$.
?$$$$$P"       .$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$.    J$$$$$$$$$$L
 ?$$P"         J$$$$$$$$$$$$$$$$$$$$$$$$F;<?$$$$$$$$$$$$$$$$.   $$$$$$$$$$$$
               J$$$$$$$$$$$$$$$$$$$$$$$$L?>J$$$$$$$$$$$$$$$$$. J$$$$$$$$$$$$
               $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$h $$$$$$$$$$$$$
               $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ $$$$$$$$$$$$$
               $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$F $$$$$$$$$$$$$
               $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$F $$$$$$$$$$$$$
              :$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$F,$$$$$$$$$$$$$
               $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$'<$$$$$$$$$$$$$
               $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ $$$$$$$$$$$$$'
               $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ $$$$$$$$$$$$F
               $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$F $$$$$$$$$$$$',
               $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$F,$$$$$$$$$$$F,;
               $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$P $$$ $$$$$$$$$$$' <C
               $$$$$$$$$$$$$P?$$$$$$$$$$$$$$$$$$$$$$$$" J$$',$$$$$$$$$$'.<C
               $$$$$$$$$$$$$h.""$$$$$$$$$$P""''.,,.""'.``"' $$$$$$$$$$',;C';
               $$$$$$$$$$$$$$$$c,"?$$$P"',;<CCC>'',;<CCCC> z$$$$$$$$$',;C' <
              J$$$$$$$$$$$$$$$$$$hc." ,<CCCCC' .<CCCC>>>> J$$$$$$$$$'.<C'.<C
              $$$$$$$$$$$$$$$$$$$$$F,<CCCCC>',CCC>'.,ccc-.$$$$$$$$P'. < ,CC>
              $$$$$$$$$$$$$$$$$$$$",<CCCC' ,cCC' .d$$$$$c$$$$$$$$" <C, --'.;
             ;$$$$$$$$$$$$$$$$$$$F,<CCC'  ,C>',c?$$$$$$$$$$$$$$P' <CCCCCCCCC
             J$$$$$$$$$$$$$$$$$$$ <CCC'  ;' ,c$".$$$$$$$$$$$$P'.<> <<<''CCC>
             $$$$$$$$$$$$$$$$$$$$ CCCC .< <$P"',$$$$$$$$$$$$'..`<<>;,;CCC>
             $$$$$$$$$$$$$$$$$$$$ CCCCCCC>;;; J$$$$$$$$$$$$' `<<;;;<CC>'
             $$$$$$$$$$$$$$$$$$$$c`<CCCCCCCC J$$?$$$$$$$$P' `>--<<<>''
             $$$$$$$$$$$$$$$$$$$$$c,`<<''.',c$P",P?$$$$P",c$cccc-
            .$$$$$$$$$$$$$$$$$$$$$$$$ ;<' c$P",d",d" 3$ c$$$$$$$
            <$$$$$$$$$$$$$$$$$$$$$$$F,<> $P".P" JP"',$',$$$$$$$F
            `$$$$$$$$$$$$$$$$$$$$$$$h <>,_ `.,< ". zP'.,,, "$$$'
             $$$$$$$$$$$$$$$$$$$$$$$$h. . <CC`<CC `" ;CC<C> $$'
             $$$$$$$$$$$$$$$$$$$$$$$$$$ $.,;;; <CC>,.,<C.CC ?'
             $$$$$$$$$$$$$$$$$$$$$$$$$$ $L`<CC>,,,;C>''C'<C,`
             ?$$$$$$$$$$$$$$$$$$$$$$$$$ $$hc,```--;;;;,`\\ CC      .     ,-
             `$$$$$$$$$$$$$$$$$$$$$$$$F $$$$$$$cc,.``CC>`<<C,   .<C>,,;>
              $$$$$$$$$$$$$$$$$$$$$$$$',$$$$$$$$$$$$.<CC C`,`<CC> ``''
              ?$$$$$$$$$$$$$$$$$$$$$$F $$$$$$$$$$$$$h`C> C `>,    _,;;;,
              `$$$$$$$$$$$$$$$$$$$$$$',$$$$$$$$$$$$$h C,'C,`;.``<'     C
               $$$$$$$$$$$$$$$$$$$$$F $$$$$$$$$$$$$$h C, <>..``-- `.   `
               $$$$$$$$$$$$$$$$$$$$$ J$$$$$$$$$$$$$$$ <>  ``<<CCC>.
               $$$$$$$$$$$$$$$$$$$$',$$$$$$$$$$$$$$$F `<>      `C>C,
               ?$$$$$$$$$$$$$$$$$$F $$$$$$$$$$$$$$$P    `<>,.   <,`<C>-
               `$$$$$$$$$$$$$$$$$$ J$$$$$$$$$$$$$$'       CCCC  'C,
                $$$$$$$$$$$$$$$$$',$$$$$$$$$$$$$$'        C,'C    ``-;
.       ..     J$$$$$$$$$$$$$$$$' J$$$$$$$$$$$$$'         CC <    ;   `-
!!!!!!!!!! ;> z$$$$$$$$$$$$$$$$' J$$$$$$$$$$$$P'          `CC>-  '
!!!!!!!!!!;'.J$$$$$$$$$$$$$$$$'.$$$$$$$$$$$$$"             `CC>>>--,_
!!!!!!!!!!'.$$$$$$$$$$$$$$$$$',$$$$$$$$$$$$$' ;;;.....       ``>    ```
!!!!!!!!! .$$$$$$$$$$$$$$$$$F J$$$$$$$$$$$" ;!!!!!!!!!! ;      `-.
!!!!!!!',c$$$$$$$$$$$$$$$$$F J$$$$$$$$$$$';!!!!!!!!!!`.<!!;.
!!!!!' ,$$$$$$$$$$$$$$$$$$F c$$$$$$$$$$$$ !!!!!!!!!! ;!!!!!!!;;...      .
!!!! .$$$$$$$$$$$$$$$$$$$' J$$$$$$$$$$$$' !!!!!!!!! ;!!!!!!!!!!!!!!!! .!!>
!!! z$$$$$$$$$$$$$$$$$P" z$$$$$$$$$$$$$' !!!!!!!!! ;!!!!!!!!!!!!!!!` <!!!!!>
!! z$$$$$$$$$$$$$$$$$" c$$$$$$$$$$$$$$';!!!!!!!!!' !!!!!!!!!!!!!!' ;!!!!!!!!
! .$$$$$$$$$$$$$$$$$' J$$$$$$$$$$$$$$F !!!!!!!!!' !!!!!!!!!!!!!!' !!!!!!!!!!
 z$$$$$$$$$$$$$$$$$F J$$$$$$$$$$$$$$P <!!!!!!!! ;!!!!!!!!!!!!!! ;!!!!!!!!!!!
z$$$$$$$$$$$$$$$$$F J$$$$$$$$$$$$$$$';!!!!!!!!` !!!!!!!!!!!!!' ;!!!!!!!!!!!!
$$$$$$$$$$$$$$$$$$'J$$$$$$$$$$$$$$$$ !!!!!!!! .!!!!!!!!!!!!! ;<!!!!!!!!!!!!!
$$$$$$$$$$$$$$$$$'.$$$$$$$$$$$$$$$$F,!!!!!!! ;!!!!!!!!!!!!' <!!!!!!!!!!!!!'
$$$$$$$$$$$$$$$$',$$$$$$$$$$$$$$$$$ <!!!!!!' !!!!!!!!!!!!`.<!!!!!!!!!!!!' .!
$$$$$$$$$$$$$$$'.$$$$$$$$$$$$$$$$$' !!!!!!! !!!!!!!!!!!! ;!!!!!!!!!!!!! .<!!
$$$$$$$$$$$$$P',$$$$$$$$$$$$$$$$$F !!!!!!! <!!!!!!!!!!! ;!!!!!!!!!!!!' ;!!!!
$$$$$$$$$$$P"  <$$$$$$$$$$$$$$$$F ;!!!!!! <!!!!!!!!!!! <!!!!!!!!!!!!`.<!!!!!
$$$$$$$$$$$ ;! $$$$$$$$$$$$$$$$$ ;!!!!!! ;!!!!!!!!!!' <!!!!!!!!!!!' ;!!!!!!!
$$$$$$$$$$';!! $$$$$$$$$$$$$$$$';!!!!!! ;!!!!!!!!!!' !!!!!!!!!!!! .!!!!!!!!!
$$$$$$$$$';!!> $$$$$$$$$$$$$$$' !!!!!! ;!!!!!!!!!!! <!!!!!!!!!!! ;!!!!!!!!'`
$$$$$$$$F !!!>,$$$$$$$$$$$$$$' !!!!!!! !!!!!!!!!!! <!!!!!!!!!!' <!!!!!!!! .<
$$$$$$$$ <!!! J$$$$$$$$$$$$$' !!!!!!! ;!!!!!!!!!! <!!!!!!!!!! .!!!!!!!! .<!!
$$$$$$$';!!!! $$$$$$$$$$$$F ;!!!!!!!! !!!!!!!!!! ;!!!!!!!!!' ;!!!!!!!` <!!!!
$$$$$$' !!!!',$$$$$$$$$$$F ,!!!!!!!!! !!!!!!!!! ;!!!!!!!!! ;!!!!!!!' ;!!!!!!
$$$$$F !!!!! $$$$$$$$$$$"  <!!!!!!!! <!!!!!!!! ;!!!!!!!!!';!!!!!!` ;!!!!!!!!
$$$$$ <!!!!! $$$$$$$$$$' / !!!!!!!!! !!!!!!!! ;!!!!!!!!! ;!!!!!! ;!!!!!!!!!!
$$$$F !!!!! z$$$$$$$$$F < <!!!!!!!!';!!!!!!! <!!!!!!!!' <!!!!!' <!!!!!!!!'',
$$$' <!!!!! $$$$$$$$$$ ;! !!!!!!!!! !!!!!!!' !!!!!!!!' !!!!'` ;!!!!!!!!` ;!!
$$' ;'!!!!',$$$$$$$$$' !! !!!!!!!! ;!!!!!!! !!!!!!!' <!!!',;<!!!!!!!!` ;!!!!
$' <! !!!! $$$$$$$$$$ !!> !!!!!!!' !!!!!!! <!!!!!!' !!!' ;!!!!!!!''`.;!!!''`
',!!! !!! z$$$$$$$$$F !!>'!!!!!!> !!!!!!' ;!!!!!!` !!' .<!!!!!!' .;!!!'` ;<!
;!!!! <!! $$$$$$$$$,,``!>'!!!!!! <!!!!!' <!!!!!! ;!' .<!!!!!!' .<!!'` ;<!!!!
!!!!!>`!>,$$$$$$$$$$$$.'>;!!!!!! !!!!!> <!!!!! .<!` <!!!!!'`.;!!'` ;<!!!!!!!
!!!!!! ! J$$$$$$$$$$$$$c'<!!!!!>'!!!!! <!!!!! ;!!` !!!!!` ;!!!' .<!!!!!!!'``
!!!!!'   $$$$$$$$$$$$$$$c !!!!! <!!!! ;!!!!' ;!` ;!!'' .<!''`.;<!!!!''`..;!!
.,,;;;;, $$$$$$$$$$$$$$$$c `'!>;!!!! ;!!!! .!`.;!!` ;<!'`.;;!!!!'`.;;<'''`..
CCCCCCCC,`??$$$$$$$$$$$$$$$c,`''!!!  !!!`.;!!!!!!!!!!!>;!!!!!!!;;!!!`.;;'''`
CCCCCCCCCC>;,,;,. "$$$$$$$$$$h  `''!!!!!!!!!!!''''```'''``'.,,,,..``''!!;<!'
CCCCCCCCCCCCCCCCCh.`$$$$$$$$$"?c  ;,``' .,;;;;;<<CCCCCCCCCCCCCCCCCCC>;,.``''
CCCCCCCCCCCCCCCCCCC,`$$$$$$$??=," `<CC>;,.""CCCCCCCCCCCCCCCCCCCCCCCCCCCCCC>;
CCCCCCCCCCCCCCCCCCCC,`$$$$, "?c,"? ..`<CCCC>.`''<CCCCCCCCCCCC>' .,;;;,,,,..`
CCCCCCCCCCCCCCCCCCCCC,`?$??$cc,"?c <C>,.``<<CCC>;.`'<CCCCCCCC ````''''''''``
CCCCCCCCCCCCCCCC,<>`C(-;,. "???= "' <<<<<C>;..``<<<-  <<CCCCC> !!!!;;;;;;<!!
CCCCC'CC <CCC >>>`C,`>.`CCC;--;;<C>--;;;;. `CCCCCC>>;>-  ``''' !!!!!!!!!!!!!
CCCC',; ,CCC>,>'C,`C,`C,``<C>,.`<CC>,.'''...;.....    <;; `'<; `''!!!!!!!!!!
CCP .> <CCC> <C CC CC,`<C>, `<<C>;.`'> <!!!!!!!!!!!!!> `<!>;;''--<; `!!!!!!!
C" /'.<CCC> <CC CC.<CC>`<>>',;;;..`'' <!!!!!!!!!!!````<;.`!!!>;;; !! !!!!!!!
 ,'.<CCCC> <CC> CC> CCC, ;;!!!!!!!!! !!!!!!!!!!!!!!!!> <!,. <!!!! !!,.`<!!!!
>',cCCCCC <CCC <CCC,<C> ;!!!!!!!!!!! <!!!!!!!!!!!!!!!!>.```>'!!!!.'` '>`!!!!
.<CCCCCC',cCCC,cCCCCCC ;!!!!!!!!!!!!- !!!!!!!!!!!!!!!!!!!>'! `!!!!!!>  '`'!!
CCCCCCC> <CCCCCCCCCC' ;!!!!!!!!''!!> !!!!!!!!!!!!!!!!!!!!!.`' !!!!!!>.``! !!
EOD
			puts venus
			self.menu_inicial
		when "picnic", "7"
			Colorear.verde_pasto
			picnic = <<EOD

                                                        ..:::::::..
                                                     .::''::::'```::
                                                    ::`.:::'..::::::`::.
                                                 .:'`:::''.:::::::``_ ``:::.
                                                ::'.:: .:::'`.,,,zd$$$$c.`::
                                                ::.': :::: ,J$$$$$$$$$$$$ ::
                                                ::'.::::: z$$$$$$$$$$$$$$h`:
                                               .:'.::::: z$$$$$$?$$$$$P"""':
                            .,,,,,,,.          ':::'.:. z$$".,,,,_ $$F  "" :
                       ,;<<!!,```'!!!!'<;,     :::.:::: $$$""'   .,$$L ccJ `
                    ,;!!!!!!!!!''- `` `'<;     `::::::: `$$$hcccc$$$$$ `CC.
                ,;<!!!' ;;,```,c$hJJ$$$c `!     .``````: `$$$$$$$$$$$$h ?C>
             ,;!!',<',;!! ,,c$$$$$$$$$$$h `>    ::: <ch : <??$$$$???$$$>`C'
             !!',<!',<!!!>`$$$$$$$$$$$$$$h !    ::`: "" :.`$$$$$Cicc,,,,='.
             `,;!! ;!!!!' z$$$$?????$$$$$$r        ::` c`: `$$$$6???"""', ::
            <!!!<! `!!!' $$$$$>=-"-,3$P".,J          : " ::.`?$$$hcc$??"  ::
           !'',;!!!;!!! $$$$$    ,"c3$   JF        ,:: b.`:::...""?$$$c$P ::
            ;!!'!! ,,.` $$$$$$c,,,z$$$'<$cc     :::::::`Mn.``:::::..`....::
           ;!! ;!` ?F'h-"$$$$$$$$$$$$$h,3$$  ,::::::::::`TMMn.``':::::::'` :
           `! !! <; ?cc$$$$$$$$$$$$". ""`3F :::::::::::::.`4MMMn,.````` ,d':
             !!!<'!'. ""3$$$$$$$$$$???=?,',.''''::::::::::::."4MMMMMP <;   .
             !!! ;! `hccJ$$$$$$$$h,.  .,r $$cccccc,.``':::::::: "4MM',!!!>'.
             `'' !!! `??$??$$$$$$$$$$ccP" `$$$$$$$$$$$c `::::::::. " <!!!> .
                 ```.?$c$h.`"?$$$P"".,,ccd$$$$$$$$$$$$$h.`::::::::::: `!!! .
                 z$$$b."?$$$$c."" ?????????"?$??"""$$$$$h ::::::::::::: `' .
              ,J$$$$$$$$$$$$$$$$c   .ii+'.::...::: $$$$$$c :::::::::::::: `.
            ,J$C$$$$$$$$$$$$$$$$$> .....:::::::::: ?$$$$$$ ::::::::::::::. .
          ,J$CS$$$$$$$???$$$$$$$F ::::::::::::::::.`$$$$$$h :::::::::::::.`.
        .c$C3$$$$$$$$$hcccc.""???'::::::::::::::::: $$$$$$$h ::::::::::::  .
       J$$C3$$$$$$$$$$$$$$$$$$cc. ::::::::::::::::: $$$$$$$$h :::::::::::.`.
      J$$7$$$$$$$$$$$$$$$$$$$$$$$c.``:::::::::::::: 3$$$$$$$$L`:::::::::: `.
     z$$?$$$$$$$$$$$$$$$$$$$$$$$$$$$c `::::::::::::.<$$$$$$$$$ `:::::::.`  .
   .J$$C3$$$$$$$$$$$$$$$$$$$$$$$$$$$$$c ``:::::::::.<$$$$$$$$$> `::::::.` `
  .$$$$C$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$hc,.```::::.<$$$$$$$$$C> :::`.:.`.`.
  J$$$C3$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$hc,.`` <$$$$$$$$$CC;`:.`:`. .
 J$$$$C$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$. <$$$$$$$$$CCC :::.:.`. .
,$$$$C3$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$h ?$$$$$$$$$CC ` ` ..`
J$$$$$$$$$$$$$$$$$$$Lz,.""?$$$$$$$$$$$$$$$$$$$$$$$$$$.$$$$$$$$$CC'J$cc. `: .
$$$$$$$$$$$$$$$$$$$$$$",c$c,`"?$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$CC $$$$$h, `.
$$$$$$$$$$$$$$$$$$$$$CJ$$$$$$hc,`"?$$$$$$$$$$$$$$$$$$$$$$$$$$$$CC $$$$$$$$c.
$$$$$$$$$$$$$$$$$$$$3$$$$$$$$$$$$hc,`"?$$$$$$$$$$$$$$$$$$$$$$$$C> $$$$$$$$$$
$$$$$$$$$$$$$$$$$$$3$$$$$$$$$$$$$$$$h c `"??$$$$$$$$$$$$$$$$$$$C> $$$$$$$$$$
$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ '      `'<<<?CCCCCCCCCCCCC>,$$$$$$$$$$
$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$P'        ==- .,,.`'''<<CCCC' J$$$$$$$$$$
$$$$$$$$$$$$$$$$$$$$$$C???$$$$$$??".       ccccccd$$$$$$$cc,..  J$$$$$$$$$$$
$$$$$$$$$$$$$$$$$$$$$$$hc,.`"""  ;;;     zd$$$$$$$$$$$$$$$$CC';$$$""$$$$$$$$
$$$$$$$$$$$$$$$$$$$$$$$$$$$$$CC>>>;;- .c$$$$$$$$$$$$$$$$$?CC>J$$C' ?$$$$$$$$
$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$CCC>' .z$$$$$$$$$$$$$$$$$$CC>JJ$$C>>' `?$$$$$$
$$$$$$$$$$$$$$$CC???999999???));;-.c$$$$$$$$$$$$$$$$$$CCCJJ$$C?>>'    "?$$$$
$$$$$$$$$$$$$$$$$$$GG66666$$$CC' z$$$$$$$$$$$$$$$$$$$CJJ$$$$C<C'        "$$$
$$$$$$$$$$$$$$$$$$$$$$$$$$$CC''z$$$$$$$$$$$$$$$$$$$CJJ$$$$$C<C'           "?
$$$$$$$$$$$$$$$$$$$$$$$$C$C' c$$$$$$$$$$$$$$$$$$$CCJJ$$$$$$CC>      nm, 4b,
?$$$$$$$$$$$$$$$$$$$$$$?J?',$$$$$$$$$$$$$$$$$$$$CJJ$$$$$$$CC>        "MMMMMM
 $$$$$$$$$$$$$$$$$$$$",=",J$$$$$$$$$$$$$$$$$$$$CJ$$$$$$$CCC>      ,="".,,`""
.?$$$$$$$$$$$$$$$??",  c$$$$$$$$$$$$$$$$$$$$$$3$$$$$$C>CCC'     =",xnMMMMMP=
h $$$$$$$$$$$$$$$,c$',J$$$$$$$$$$$$$$$$$$$$$$$$$$$$$C><CC'       nMP"".,,===
Mx`$$$$$$$$$$$$$$$$F.J$$$$$$$$$$$$$$$$$$$$$$$$$$$$C>><C>'      ,J" =4MMMMndM
MMr`$$$$$$$$$$$$$$$L;$$$$$$$$$$$$$$$$$$$$$$$$$$$C>><CC>     ,nMMP ,xnMMMMMMM
MMM ?$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$C>><CC'    ,dMMP",dMMMPPPPPPP
MMMb $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$C>><CC>'     ""P",nMMMMLxdMMMMM
MMMM.?$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$C><<C>>',xmnmn,`=nMMP""3MMMMMMMMM
MMMM>`$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$CC>>'',xnMMMMMMMMb 4MP dMMMMMMMMMMM
")MMM ?$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$CC>' ,xPPPP"""" .,.""x M dMMMMMMMMMMMM
h "MMb."$$$$$$$$$$$$$$$$$$$$$$$$$$$CC>'  ="',x= nMMMMMMMMP M Jx`4MMMMMMMMMMM
"  4MMM,`"?$$$$$$$$$$$$$$$$$$$$$$C>'',nmnmPP" xMMMMPP"C"MMMM;MMbx`""".,,."PP
 Mb,"MMMMn "$$$$$$$$$$$$$$$$???"".,uPPPP",xmM MMM"_,`=""44MMMMMMM,ndMMMP .::
.`"M,`"4444mnn,,`"""""""""",unmdMMMMMMbmMMMMM,4M>:MMMMMMn,MMPPPPP"""....::::
:::."MMbmn,`"4MMMMMMMMMPPPPMMMMMP""")MMMMMMMMh`".,,xmnn MP"...::::::::::::::
EOD
			puts picnic
			self.menu_inicial
		when "facundo", "33"
			Colorear.default
			facundo = <<EOD
,,....,,,,,.,,,,,,,,,,,,,,,,,,,,,,,,,,:::::::::::::::~~~~~~~~~~~~~~~~~~=====
,,,,.,,...,,,,,,,,,,,,,,,,,,,,,,,,,,.,::::::::::::::~~~~~~~~~~~~~~=~===~====
,,,,,,,.......,,,,,,,,,,,,,,,,,::,,,,,,..,,,:,,:::::~~~~~~~~~~~~=~~=========
,,,,,,,,,,.,,...,.,,,,,,,,,,:,,:,,:,,,.,,,.,,,,,,::~:~~~~~~~~~~~~~~~~=======
,,,:,,,,.,,,,,,,,...,..,,,:,,........,..,,...:.,,,:::~~~~~~~~~=~~~~=========
,::,,,,,,,.,,,,,,,,,:,,,:,:,.............,,..,,,,,::,:~~~~~~~~~~~===========
:::,,,,,,,.,,,,,,,,,,...:,,..............,.......,,:::::~~~~=~=~===~========
:,:,,,,,,,,,,,,,:::,,...........................,.,,:::~~~~~~~~~============
,,:,,,,,,,.,,,,::,,,,..,.........................,:,,,,,~~~=================
:,,:::,,,,,,,,,:,...,,...,....,..................,,.,,,,,~=~~===============
:,,,:,,,,,,,,:,,.,:,,,,:,.......,,,.,,...........:.:,,,,,~~~================
,,:,,,,,,,,,,:,.,....,:.,..,,,::~~~==~=~:,,.......,...,,~~==================
,,,::,,,:,.,..,,...........,~++??I?++++++=~:,..........,,:=~================
:::,,:,,,:...,,,..,.......:+?IIIII??????+++~::,.......,:,,~=================
::,::::,,...............,:+IIIIIIIIII????+++~~~:,....,::.~~=================
:,:,:::..............,,,:+?II7I7IIIII????++++=~~~,....:,~===================
:::::,:,..........,.,,:==??III7I7IIII??????+++==~~...,:~=~==================
:::::::,...........,,:~++???IIII??????++++++++++=~~...,~===================+
:::::::,.,,........,::++?=,...:~~~=======+++++??++=,.,:~~===================
,::::,:,,..........,:,,,~..==:~,.,:,.,:~~=====++++==,,======================
,::,:,,,,........,,,.....,,=:::,,,,..,:..,~~=====~~~~~=~====================
:,:::::,..........,~++=~::,:,:~:::::,,,,,...~~~~::,:::~~====================
:,::::,?I?..,.....,,,==~:,,.~~::::,:,,,,,...,~........,~====================
:,::::=::??:~...:~:,,,:=:,,.,:~~::~~,:,,,,:.~,...,,,,.~~,.,=================
::::::~::,=?+,.,:+++~:::=+=.~~:~~::,,:,,,:=.~+..,,,,,,..,,.,================
:::,:=~:?:,~==.,:++++??:::=~.:::::::::::~:.~II+.?=.,.....+.=================
,,:,,:~+~~,:~=,~=++++????:::.,~~~:::~:~==,:III?+::,,:,===~,=================
::,:,,?=~::,I?==+==++++???=::~=.,~=~~~=::~IIIII?=::~~=====~=================
::,,,,?I?~:???++=+==+++++++=~~=?+?+=+??~~?III7I?+:::~===:,==================
::,,,,I~I?~~=?+=======+++++?+~~=+?++?+~~?+====+==~:~~==:.===================
::,,,,+I++II=+++======+++++?++~~=++++=:::...,::::~~~~=======================
::,,,,,III??+=++======++++++??+=~==+?+,,:,::::::~~~=~~======================
:,,,,,,~+??++==========+++++???+=~~=~~~:,::~~~:~~~~~~~~=====================
,,,,:.,~+,,,,==========++++?++??+~:~:~=+?I?~~~~~~~~~:~~~~~==================
:,,,,,.?+,,,,~=~========+++++++++:~=+?II?II?~~~~~~~~,:~=~~~=================
,....,:??::,,~~~~==========++++++==+???+~:::~=::~~~:..,:~~~~~===============
......,??+:,~~~~~=====~=~========~~~::,,,,,,,,,,:~::::~~::~~~~~=============
........+??++~~~~~~~~~~~~~=~==~~::,,.,,,,~~:::::,::.,,::~~==~~~~============
.........+?++=~::~~~~~~~~~~:~::::::::::::,,,,,,,:,,...,::+??=~~~~===========
..........,++=~:,:::~~~~~:~~::::::::::::::::,,:,,,.....,,+?+~~~~============
...........,==~:,,,,::::~:::::::::::::::::::::::,......,~++=~~~~============
............,=~~,,...,::::::~~~~=~==++=~:~~::~::.......,:++=~~~~=~~=~=======
..............~::,,....,,:,,:::~===++++++~~~~:~:....,,,::==~~~=~==~~~~~====~
...............::,,........,,,::~~=======~~:~~::,..,::::~~~~~==~==~~~~~~==~=
................,,,............,,,::::::::::::::,:~::~~~~~~~~~~~==~~~~~==~~=
..................,,,.............,,,,,,::,:,,,::~~~~~~~~~~~~~~~~~~~~~~~~~==
...................,,,,,...............,,,.,::~~~~~~~~~::::~~~~~~~~~~~~~~~~~
.....................,,,,,..........,,,,,:::~~~~~~~~~::::~~~~~~~~~~~~~~~~~~~
..................................,,,,:::~~:~~~~~~::,,:~~~~~~~~~~~~~~~~~~~~~
..................................,,,:::::::::::::,,:~~~~~~~~~~~~~~~~~~~~~~~
................................,.,::::::::::::.....,~~~~~~~~~~~~~~~~~~~~~~~
..................................,:::::::,,,,.......~~~~~~~~~~~~~~~~~~~~~~~
...............................,,.:::::::::,.........,~~~~~~~~~~~~~~~~~~~~~~
...............................,,:==~::~:,...........,~~~~~~~~~~~~~~~~~~~~~~
..............................~::===~:,...............~~~~~~~~~~~~~~~~~~~~~~
..............................~~~~:...................:~~~~~~~~~~~~~~~~~~~~~
.......................................................:~:~~~~~~~~~~~~~~~~~~
........................................................::~:~:~~~~~~~~~~~~:~
........................................................,::::~~:~:::~~~~~~~:
.........................................................,~~:~:~~~~~~~:~~~~~
..........................................................:~:~:~~:~~~:~~~:::
...........................................................::~:~~:~~~~~~:::~

EOD
			puts facundo
			self.menu_inicial
		when "mcdonald", "0"
			Colorear.verde_pasto
			mcdonald = <<EOD

~  OLD MACDONALD HAD A FARM.............eieio!  ~

        , .    .--.
        _|__  |____|
       /    \\ |____|
     /   []   |____|
    |__________|  |                          
    |   ____   |  |        _
    |  |\\  /|  |  |      _[_]_
    |  | \\/ |  |  |       c")
    |  | /\\ |  |  |      ,(_)'
    |__|/__\\|__|__|       -"-


and on his farm there was a pig......eieio


           ||            ||   (\\../)   ||           ||
          _||____________||____(oo)____||___________||_
          -||------------||---"----"---||-----------||-
          _||____________||__@( __ )___||___________||_
          -||------------||----"--"----||-----------||-
           ||            ||            ||           ||
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^


and on his farm there was a rooster......eieio

         ,   #
        (\\\\_(^>
        (_(__)`
           ||
          _||___
          -||---
          _||___
          -||---
           ||
        ^^^^^^^^^^

and on his farm there were some ducks....eieio   
 --         _                          _
        ,__(^<        >@)_,           (')<       >O___,
        \\___)          (_>)          <~_)         (_=/
          ||            ||            ||           ||
         _||____________||____________||___________||_
         -||------------||------------||-----------||-
         _||____________||____________||___________||_
         -||------------||------------||-----------||-
          ||            ||            ||           ||
       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^


and on his farm there was a cow......eieio

                                       __.----.___
           ||            ||  (\\(__)/)-'||      ;--` ||
          _||____________||___`(QQ)'___||______;____||_
          -||------------||----)  (----||-----------||-
          _||____________||___(o  o)___||______;____||_
          -||------------||----`--'----||-----------||-
           ||            ||       `|| ||| || ||     ||
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

and on his farm there was a sheep......eieio

                              {^--^}.-._._.---.__.-;
           ||            ||   {6 6 }.')' (  )  ).-`  ||
          _||____________||___( v  )._('.) ( .' )____||_
          -||------------||----`..''(.'  (   ) .)----||-
          _||____________||______#`(.'( . ( (',)_____||_
          -||------------||-------'\\_.).(_.). )------||-
           ||            ||        `W W     W W      ||
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Put them all together and you have:

   ,   #                                                     _
  (\\\\_(^>                            _.                    >(')__,
  (_(__)           ||          _.||~~ {^--^}.-._._.---.__.-;(_~_/
     ||   (^..^)   ||  (\\(__)/)  ||   {6 6 }.')' (. )' ).-`  ||
   __||____(oo)____||___`(QQ)'___||___( v  )._('.) ( .' )____||__
   --||----"- "----||----)  (----||----`-.''(.' .( ' ) .)----||--
   __||__@(    )___||___(o  o)___||______#`(.'( . ( (',)_____||__
   --||----"--"----||----`--'----||-------'\\_.).(_.). )------||--
     ||            ||       `||~|||~~|""||  `W W    W W      ||
   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
EOD
			puts mcdonald
			self.menu_inicial
		when "gato", "cheshire", "9"
			Colorear.verde_pasto
			gato = <<EOD

                   .'\\   /`.
                 .'.-.`-'.-.`.
            ..._:   .-. .-.   :_...
          .'    '-.(o ) (o ).-'    `.
         :  _    _ _`~(_)~`_ _    _  :
        :  /:   ' .-=_   _=-. `   ;\\  :
        :   :|-.._  '     `  _..-|:   :
         :   `:| |`:-:-.-:-:'| |:'   :
          `.   `.| | | | | | |.'   .'
            `.   `-:_| | |_:-'   .'
              `-._   ````    _.-'
                  ``-------''
EOD
			puts gato
			self.menu_inicial
		when '"bob"', "666", "dios"
			Colorear.verde_pasto
			bob = <<EOD

                     $$$$$$$$$$$$$$$$$$$$$$
                  $$$$$$$$$$$$$$$$$$$$$$$$$$$$
                $$$$$$$$$$$$$$$$$$$$$$$$$$$ $$$$$
               $$$$$$$$$$$$$$  $$$$$$$  $$   $ $$$$
             $$$$$$$$$$$   $$   $$$  $$  $   $  $$$$
            $$$$%$$$  $ $   $$   $$$  $  $   $$ $ $$
           $$$$%%$$$   $ $   $$   $$$  $  $$  $ $ $$$
          $$$$$%%$$$$  $ $    $    $$  $  $$$ $ $$ $$$$
         $$$$$%%%$$$$$ $$$$   $  $ $$   $ $$$$$ $$ $$$$$
        $$$$$$%%%$$$$$$$$$$$  $$ $ $$$$ $ $$$$$$$$$$$$$$$$
       $$$$$$%%%$$$$$$$$$$$$$$$ $$$$$$ $$$$$$$$$$$$$$$$$$$
      $$$$$$%%%$$%%%%%%$$$$$$$$$$$$$$$ $$$$$$$$$   $$$$$$$$
      $$$$$$%%$$%%%%%%%%%$$$$$$$$$$$$$ $$$$$$$     $$$$%$$$
      $$$$$$%$$%%%%%%%%%%%$$$$$$$$$$$$$$$$$        $$$$%%$$$
      $$$$$$$$%%%%%%%%%%%%%$$$$$$$$$$$             $$$$%%$$$
     $$$$$$$%%%            $$$$$$$$                 $$$%%$$$
     $$$$$$%%%                                      $$$%%$$
     $$$$$$%%%                                      $$$%%$$
     $$$$$%%%%                                    % $$$%%$$
     $$$$$%%%%                                    %  $$%%$$
     $$$$$%%%%                                    %  $$%%$$
     $$$$$%%%%                                   %%  $$$%$$
     $$$$$%%%%                                  %%%  $$$%$$
     $$$$$%%%%                                   %%  $$$%$$
     $$$$$%%%%                                   %%  $$$%$$
     $$$$$%%%%                                   %%  $$$%$$
      $$$$%%%%                             $$$$  %% $$$$%$$
     $ $$$%%%% $$$$$$$$$                $$$$$$$$$%% $$$$$$$
    $$$ $$%%%  $$$$$$$$$$              $$$$$$$$$$$%% $$$$$$
    $$$$  %%%          $$$           $$$$       $$%% $$$$$$
    $$$$$$%%%    $$$$$ $$$$         $$$$$$$$$$   $%% $$$$$$
     $$$$ %%%  $$$     $$$$$       $$$$$$    $$$  %%% $$$$$
     $$$$     $$$$$$$$$ $$$$      $$$$$$$$$$$$$$   %  $$$$$
     $$$$     $$$  $ $$  $$$$    $$$$$$  $ $  $$      $$$$
     $$$$      $   $$$ %%%$$$         %% $$$          $$$$
     $$$$             %%%% $$         %%%%%%  %%%     $$$$
      $$$$      %%% %%%%%   $           %%%%%%%       $$$$
      $$$$        %%%%%    $$             %%%         $$ $
      $$ $          %%     $                          $ $$
      $ $$                 $                          $  $
      $ $$  $             %$                         $$  $
      $  $  $            %%$                          $$$$
       $$$  $$         $ %%%                       $ $ $$
        $$  $$        $ %%%%          $ $$$       $$ $
         $ $$$     $$  %%%%        $$$  $$$     $$$ $
         $ $$$    $$  %%%$$$     $$$$    $$$$  $$$$ $
         $$$$$$$$$$   $$$$$$$$$$$$$$      $$$$$$$$$ $
          $$$$$$$   $$$$$$$$$$$$$$         $$$$$$$$ $
          $$$$$$ %%$$$$$$$$$$$$$$      $$$$$$$$$$$$$$
          $$$ $$  %$$$$$$$$$$      $$$$$$$$$    $$$$
           $$  $   $$$$     $$$$$$$$    $$      $$$
           $$  $   %$$$$               $$      $$$$
            $  $   %%%%$$$ $$$$$$$$$$$$$       $$$
            $$ $$   %%%%             $$       $$$$
            $$ $$    %%$$$$ $$$$$$$$$$        $$$
             $  $    $$$$$%%%%%%%%%%         $$$$
             $$ $$  $$$$$%%%                 $$$
              $  $ $$$$ %%%%%%%%%%%%%%      $$$
              $$  $$$$  %%%%%%%%%%%%%       $$$
     $$$       $ $$$$   $%%%%              $$$
   $$   $$      $$$$$  $$$$               $$$
  $  $$  $$   $$$$$$   $$$                $$$
 $ $$$$  $$  $$$$$$   $$$$               $$$
$  $$$  $$$ $$$$$$ $$$$$$$              $$$
$      $$$$$$$$$$   $$$$$$             $$$
$  $$   $$$$$$$$     $$$$$$$$$$$$$$$  $$$
$$$$$   $$$$$$$       $$$$$$$$$$$$$$$$$$
$$$$$$   $$$$$                  $$$$$$
 $$$$$   $$$$
 $$$$$$  $$$
  $$$$$  $$$
   $$$$$$$$
    $$$$$$
EOD
			puts bob
			self.menu_inicial
		when "beatles", "4"
			Colorear.verde_pasto
			beatles = <<EOD

 
 
                                                                   .od88888bo.
    _.ooooo._                               _.oooooo._           .d88888888888b
  .d888888888b                            _d8888888888b.        d88888888888888
 .888888888888b                          d88888888888888b_     d888888888888888
d888888888888888b.                      d88888888888888888b    8888888888888888
8888888`"Y8888888b          ____       d8888888888888888888b   888888P""Y8888P8
88P'  _|  |`_ `Y88      .ood88888b.    88888888""""`Y8888888b  88P' =,  \\  =-
88P  '-'   `-` `Y8     d88888888888b.  888P  ' ,=-   `Y8888"Y  88P'      `     
888             Y8    d88888888888888b  Y/ _ `.       |888p 8  88     _-_      
| Y     '"`      8\\  d888888P""""""Y88b \\ /"|          Y - .8  |Y     ' '    
\\\\     ."-".    |// 888888P' '_   \\_ `Y  J  |'-)        |-'88  \\`    _.--._
 `-    -----`   |'  888888P -'"    \\".|   |  " ___      | 888   `|   '  -     
  Y      =     /Y   8P Y88     , -' ) |    \\ |"-'     .'  Y88    `.    `      
   |         .' F   \\| ,Y8b    / ___  F     \\ '_.'  .'     Y8     |`--.___.--
  / `. ` ---'  |     \\         -'._.\\|       \\    .'        Y_    )         
.<    `-       |      \\`-'        =  |        `._'         .' \\.-'|        _. 
  `-.   `.     |       Y| `     _   /            )-._    .'    /  |`-.__.-'   /
     \\    \\__.'|       `|        `""|           J\\   `-.'     /  J   .-.    
      \\    /\\  |`.      |           |           / \\   / \\    /   /   (  )  
       \\   | | |  `-   / \\     `    |        _.'   \\  \\ |   /    \\    ) |
        \\  | | |    `./   `.       _|    _.-'       \\  | \\ /      \\   | '
         \\ | | |       \\    `.__.-' |_.-'            `.|  V        \\  /
          \\| | /        \\     / \\  / \\                 \\  /         \\/
           \\ | |         \\    \\ ( /                     \\/
            \\|/           `.  | |/
             V              \\ | /
                             `.'                                     
EOD
			puts beatles
			self.menu_inicial
		else
			puts
			Colorear.rojo
			puts "#{opcion} No es una opción válida, elija otra opción"
			puts
			self.menu_inicial
		end
	end

end

Jugar.menu_inicial

gets
