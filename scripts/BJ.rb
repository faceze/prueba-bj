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

# clase para colorear el texto de la consola (por el momento solo windows)
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
	# => AMARILLO : 14
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

	def self.amarillo
		@set_console_txt_attrb.call(@hout,14)
	end

	def self.blanco
		@set_console_txt_attrb.call(@hout,15)
	end

end

########################

class SaveGame

	def self.crear
		File.open("savegame", "w") do |f|
			f.write(Base64.encode64("1000"))
		end
	end

	def self.guardar
		# Acá va el código para guardar la partida
		sustitucion = self.cargar.gsub!(/^-?\d+$/){$numero_nuevo}#(/\b(-?\d+)/){$numero_nuevo} #-? están para captar si el número es negativo

		File.open("savegame", "w") do |f|
			f.write(Base64.encode64(sustitucion))
		end

	end

	def self.cargar
		# Acá va el código para cargar la partida
		File.open('savegame', 'r') do|f|
			Base64.decode64(f.read)
		end
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

	def self.imprimir_monedas
		numero = $monedas.scan(/^-?\d+$/) #(/\b(-?\d+)/) # -? para ver si el número es negativo
		$numero_viejo = numero.join.to_i
		puts
		print "  Monedas : "
		if $numero_viejo <= 0
			Colorear.rojo
		else
			Colorear.amarillo
		end
		print "%06d" % $numero_viejo #para cambiar la cantidad de monedas hacer $numero_viejo = ... o $numero_viejo +=, -= apuesta...
		puts
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
		#

		#############################################--COMPUTADORA--##################################################
		self.imprimir_monedas
		puts
		Colorear.verde_pasto
		puts "  MIS CARTAS SON (PC):"
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
				
		#Comprueba qué valor va a tener la carta A
		if mi_carta_uno[0] + mi_carta_dos[0] == 22
			suma_mis_cartas = mi_carta_uno[0] + mi_carta_dos[0] - 10
		else
			suma_mis_cartas = mi_carta_uno[0] + mi_carta_dos[0]
		end

		Colorear.verde_pasto
		print "Valor de mis cartas: "
		Colorear.rojo
		print "#{mi_carta_uno[0]} + ?"#{suma_mis_cartas}"
		Colorear.default
		puts

		###############################################--JUGADOR--##################################################
		puts
		Colorear.verde_agua
		puts "  TUS CARTAS SON (USUARIO):"
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
						

		#Comprueba qué valor va a tener la carta A
		if tu_carta_uno[0] + tu_carta_dos[0] == 22
			suma_tus_cartas = tu_carta_uno[0] + tu_carta_dos[0] - 10
		else
			suma_tus_cartas = tu_carta_uno[0] + tu_carta_dos[0]
		end

		Colorear.verde_agua
		print "Valor de tus cartas: "
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
			"¿Es un buen momento para decirte que me acosté con tu mamá?", "Yo no pierdo, recopilo información de tu comportamiento en situaciones de \"triunfo\"."]

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
			"¿Por qué no volvés a jugar esos jueguitos de disparos? Me parece que te va mejor en eso, ¿no?", 
			"¿No sería gracioso que una computadora sea capaz de reírse de vos?"]



		#El jugador decide qué hacer (pedir otra carta o plantarse) teniendo acceso a solo una de las dos cartas repartidas (la otra boca abajo)
		#Si la PC saca 16 o menos, debe sacar otra carta, si es 17 o más debe plantarse
		#Hay que fijarse qué pasa cuando se tienen dos Aces..... mejorar el comportamiento en estas situaciones
		unless suma_tus_cartas == 21
			puts
			puts
			puts
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
		self.imprimir_monedas
		puts
		Colorear.verde_pasto
		puts "  MIS CARTAS SON (PC):"
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
		puts "  TUS CARTAS SON (USUARIO):"
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
		
		puts
		puts
		puts
#############################################################################FIN DEL CÓDIGO REPETIDO PARA REFACCIONAR Y METER EN UN MÉTODO############################


		#Repartija de frases inteligentes de acuerdo a la puntuación
		if suma_tus_cartas == 21 && suma_mis_cartas != 21 && tu_carta_extra == nil
			Colorear.verde_brillante
			puts "¡BLACKJACK! — GANASTE"
			Colorear.default
			puts frases_derrota_blackjack[rand(0...frases_derrota_blackjack.length)] #Van los 3 puntos suspensivos (o .. y un length-1) porque length cuenta desde uno y el array desde 0
			$numero_viejo += 333
			$numero_nuevo = $numero_viejo
			SaveGame.guardar

		elsif suma_mis_cartas == 21 && suma_tus_cartas != 21 && mi_carta_extra == nil
			Colorear.rojo
			puts "¡BLACKJACK! — PERDISTE"
			Colorear.default
			puts frases_victoria_blackjack[rand(0...frases_victoria_blackjack.length)]
			$numero_viejo -= 100
			$numero_nuevo = $numero_viejo
			SaveGame.guardar

		elsif suma_mis_cartas > 21
			Colorear.verde_brillante
			puts "GANASTE"
			Colorear.default
			puts frases_derrota[rand(0...frases_derrota.length)]
			$numero_viejo += 100
			$numero_nuevo = $numero_viejo
			SaveGame.guardar

		elsif suma_tus_cartas > 21
			Colorear.rojo
			puts "PERDISTE"
			Colorear.default
			puts frases_victoria[rand(0...frases_victoria.length)]
			$numero_viejo -= 100
			$numero_nuevo = $numero_viejo
			SaveGame.guardar

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
			$numero_viejo -= 100
			$numero_nuevo = $numero_viejo
			SaveGame.guardar

		elsif suma_tus_cartas > suma_mis_cartas
			Colorear.verde_brillante
			puts "GANASTE"
			Colorear.default
			puts frases_derrota[rand(0...frases_derrota.length)]
			$numero_viejo += 100
			$numero_nuevo = $numero_viejo
			SaveGame.guardar
		end

		puts

		gets
		self.menu_inicial
			
	end

	def self.menu_inicial
		titulo1 = <<EOD
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
EOD

		titulo2 = <<EOD
	| `---' |                                                            |
	|       |                                                            | 
	|       |                                                           /
	|       |----------------------------------------------------------'
	\\       |
	 \\     /
	  `---'

EOD
		Colorear.rojo
		puts titulo1
		print "	|\\|  | /|             "
		Colorear.amarillo
		print "FACUNDO'S BLACKJACK PARADISE"
		Colorear.rojo
		print "                   |\n"
		puts titulo2
		puts "		Elija una opción:"
		puts "		▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒"
		puts
		Colorear.blanco
		print "		 1 "
		Colorear.verde_brillante
		print "→ "
		Colorear.default
		print "Comenzar un juego nuevo\n"
		Colorear.blanco
		print "		 2 "
		Colorear.verde_brillante
		print "→ "
		Colorear.default
		print "Continuar partida\n"
		Colorear.blanco
		print "		 3 "
		Colorear.verde_brillante
		print "→ "
		Colorear.default
		print "Salir\n"
		Colorear.rojo
		puts
		puts "		▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒"
		Colorear.verde_agua
		print " → "
		Colorear.default
		opcion = gets.chomp
	
		case opcion
		when "1"
			SaveGame.crear
			$monedas = "1000" #Si no inicializamos la variable nos dará error cuando intente acceder a ella la primera vez
			self.iniciar
		when "2"
			if File.exist?("savegame")
				$monedas = SaveGame.cargar
				self.iniciar
			else
				SaveGame.crear
				$monedas = "1000" #Si no inicializamos la variable nos dará error cuando intente acceder a ella la primera vez
				self.iniciar
			end
		when "3"
			exit
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
		
		else
			begin #Crea una excepción para evitar que se cierre el programa al ingresar ciertos caracteres
				puts
				Colorear.rojo
				raise "#{opcion} No es una opción válida, elija otra opción"
				puts
			rescue Exception => e
				puts e.message #mensaje de error
				self.menu_inicial
			end
		end
	end

end

Jugar.menu_inicial

gets
