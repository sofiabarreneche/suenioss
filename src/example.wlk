class Persona{
	var suenios
	var sueniosPendientes = #{}
	var sueniosCumplidos = #{}
	var carrerasQueQuiereEstudiar = #{}
	var property carrerasHechas = #{}
	var property lugaresADondeViajar = #{}
	var lugaresConocidos = []
	var property cantidadHijos 
	var property cantidadDineroDeseado
	var tieneTrabajo
	var personalidad 
	var felicidad
	
	
	method esAmbiciosa() = self.suenioAmbicioso().size() > 3
	method suenioAmbicioso() = suenios.filter({unSuenio => unSuenio.esSuenioAmbicioso()})
	method esFeliz() = felicidad > sueniosPendientes.sum({unSuenio => unSuenio.felicidad()})
	method cumplirSuenio(){
		const suenio = personalidad.realizarSuenio(sueniosPendientes)
		suenio.cumplirSuenio(self)
	}
	method tenerHije(){
		cantidadHijos += 1
	}
	method aumentarFelicidad(cant){
		felicidad += cant
	}
	method adoptarHijes(cant){
		cantidadHijos += cant
	}
	method viajar(unLugar){
		lugaresConocidos.add(unLugar)
	}
	method conseguirTrabajo(){
		tieneTrabajo = true
	}
	method quiereEstudiar(nombreCarrera) = carrerasQueQuiereEstudiar.contains(nombreCarrera)
	method recibirse(nombreCarrera){
		carrerasQueQuiereEstudiar.remove(nombreCarrera)
		carrerasHechas.add(nombreCarrera)
		
	}
}



class Suenio{
	var property felicidad
	method cumplirSuenio(persona){
		self.realizarSuenio(persona)
		self.aumentarFelicidadPersona(persona)
	}
	method aumentarFelicidadPersona(persona){
		persona.aumentarFelicidad(felicidad)
	}
	method realizarSuenio(persona){}
	method esSuenioAmbicioso(){
		felicidad > 100
	}
}



object recibirse inherits Suenio{
	var nombreCarrera
	method condicion(persona){
		if(persona.quiereEstudiar(nombreCarrera) and not(persona.carrerasHechas().contains(nombreCarrera))){
			self.realizarSuenio(persona)
		}
	}
	override method realizarSuenio(persona){
		persona.recibirse()
	}
}


object adoptar inherits Suenio{
	var cantHijosAAdoptar
	method condicion(persona){
		if(persona.cantidadHijos() > 1){
			self.error("no puede adoptar, ya que tiene hijos")
		}else self.realizarSuenio(persona)
	}
	override method realizarSuenio(persona){
		persona.adoptarHije(cantHijosAAdoptar)
	}
}


object tenerHije inherits Suenio{
	
	method condicion(persona){
		self.realizarSuenio(persona)					
	}
	override method realizarSuenio(persona){
		persona.tenerHije()
	}
}


object viajarAUnLugar inherits Suenio{
	var nombreLugar
	method condicion(persona){
		if(persona.lugaresADondeViajar().contains(nombreLugar)){
			self.realizarSuenio(persona)
		}else self.error("la persona no desea viajar a ese lugar")
	}
	override method realizarSuenio(persona){
		persona.viajar(nombreLugar)
	}
}


object conseguirLaburo inherits Suenio{
	var sueldo
	method condicion(persona){
		if(persona.sueldoDeseado()> sueldo){
			self.error("el sueldo es muy poco")
		}else self.realizarSuenio(persona)
	}
	override method realizarSuenio(persona){
		persona.conseguirTrabajo()
	}
}


object suenioMultiple inherits Suenio{
	var suenios = #{}
	method felicidad(persona) = 			//aca para mi no deberia haber persona, pero si no no se me ocurre como seria
		suenios.sum({unSuenio => unSuenio.aumentarFelicidad(persona)})
	
	override method cumplirSuenio(persona){
		suenios.forEach({unSuenio=>unSuenio.condicion(persona)})
	}
}


object realista{
	method realizarSuenio(sueniosPendientes){
		sueniosPendientes.max({unSuenio =>unSuenio.felicidad()})
	}
}


object alocado{
	method realizarSuenio(sueniosPendientes){
		sueniosPendientes.anyOne()
	}
}


object obsesivo{
	method realizarSuenio(sueniosPendientes){
		sueniosPendientes.first()
	}

}
