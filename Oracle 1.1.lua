// Indicador manda señales de compra y venta
//EFECTIVIDAD CUANDO:
//La + te marca el cambio de tendencia
//Cuando la bandera roja coincide con sobrecompra y +
//Cuando la bandera verde coincida con sobreventa y +
//Aparece un simbolo cuando es momento de comprar o vender
//%K = 100 x ((C-Min) / (Max – Min))
//%D = Media móvil simple de n períodos del %K

//Teniendo en cuenta esto, sabemos que:

//– C: precio de cierre de la última sesión.
//– Min: precio mínimo alcanzado durante un número determinado de sesiones.
//– Max: precio máximo alcanzado durante un número determinado de sesiones.
//Como podemos apreciar , para configurar el indicador hay que señalar dos variables:
//– Número de sesiones a considerar. Valores habituales suelen ser 15 ó 20 sesiones.
//– Número de períodos (n) a considerar para el cálculo de la media móvil %D. Valores habituales suelen ser 3 ó 5
////////////////////////////////////////////////////////////////
//@version=4
// Created by: Alan Colin, 2022 
///////////////////////////////////////////////////////////////
study(title="Oracle", shorttitle = "Oracle", overlay = false, format = format.price, precision = 2)
 
//Input
periodK = input(14, title="K", minval=1)
periodD = input(3, title="D", minval=1)
smoothK = input(3, title="Smooth", minval=1)
hlsto1 = input(70, title="Level Oversold")
hlsto2 = input(30, title="Level Overbought")
showalert = input(defval = true, title="Show Alert")
 
//Setting
k = sma(stoch(close, high, low, periodK), smoothK)
d = sma(k, periodD)
 
//My Colors
Color00 = #f57f17//Orange
Color02 = #f57f17ff//Orange 100%
Color10 = #006400//Green
Color11 = #00640080//Green 50%
Color12 = #006400ff//Green 100%
Color20 = #8B0000//Red
Color21 = #8B000080//Red 50%
Color22 = #8B0000ff//Red 100%
Color30 = #ffffff//White
Color31 = #808080//Gray
Color32 = #000000//Black
 
//Drawing
plot(k, title="%K", color = Color10, linewidth = 3)
plot(d, title="%D", color = Color20, linewidth = 3)
h1 = hline(hlsto1, color = Color31, linestyle = hline.style_dotted, linewidth = 1, title = "Level Oversold")
h2 = hline(hlsto2, color = Color31, linestyle = hline.style_dotted, linewidth = 1, title = "Level Overbought")
 
//Setting Alert Signal
crosssto = cross (k, d)
overlevel = k >= hlsto1 or k <= hlsto2
stoBuySignal = k >= hlsto1 and crosssto
stoSellSignal = k <= hlsto2 and crosssto
stoBS = 0
stoBS := stoSellSignal ? 1 : stoBuySignal ? 2 : nz(stoBS[1])
 
//Drawing Alert Signal
plot(showalert and crosssto and overlevel? k : na, style = plot.style_cross, linewidth = 3, color = Color02, title = "Cross K & D")
plotshape(showalert and stoBS != stoBS[1], color = stoBS == 1 ? Color10 : Color20, style = shape.flag, size = size.small, location = location.bottom, title = "Oversold/Overbought")
 
