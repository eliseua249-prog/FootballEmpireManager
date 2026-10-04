extends Control

var club := "Aurora FC"
var money := 18500000
var points := 0
var wins := 0
var draws := 0
var losses := 0
var morale := 74
var week := 1
var tactic := "4-3-3 Posse"
var last_result := "Nenhuma partida disputada"
var rng := RandomNumberGenerator.new()

func _ready():
    rng.randomize()
    queue_redraw()

func _draw():
    var w=size.x
    var h=size.y
    draw_rect(Rect2(0,0,w,h),Color("#09111f"))
    draw_string(ThemeDB.fallback_font,Vector2(30,55),"⚽ FOOTBALL EMPIRE",HORIZONTAL_ALIGNMENT_LEFT,-1,32,Color("#2dd4bf"))
    draw_string(ThemeDB.fallback_font,Vector2(30,105),"Painel do Clube",HORIZONTAL_ALIGNMENT_LEFT,-1,44,Color.WHITE)
    draw_string(ThemeDB.fallback_font,Vector2(30,140),club+" • Semana "+str(week),HORIZONTAL_ALIGNMENT_LEFT,-1,21,Color("#91a4bf"))

    card(Rect2(25,175,w-50,190))
    label("PRÓXIMO JOGO",50,215,19,Color("#91a4bf"))
    label(club,50,265,31)
    label("VS  Vale Azul",50,310,31,Color("#f5c451"))
    label("Domingo • 16:00 • Casa",50,345,19,Color("#91a4bf"))
    button(Rect2(w-260,230,205,70),"JOGAR",Color("#f5c451"))

    stat(Rect2(25,395,(w-75)/2,105),"ORÇAMENTO","R$ "+money_text(money))
    stat(Rect2((w+25)/2,395,(w-75)/2,105),"MORAL",str(morale)+"/100")
    stat(Rect2(25,520,(w-75)/2,105),"PONTOS",str(points))
    stat(Rect2((w+25)/2,520,(w-75)/2,105),"CAMPANHA",str(wins)+"V "+str(draws)+"E "+str(losses)+"D")

    card(Rect2(25,650,w-50,235))
    label("ÚLTIMA NOTÍCIA",50,690,19,Color("#91a4bf"))
    label(last_result,50,740,22)
    label("Tática: "+tactic,50,785,20,Color("#91a4bf"))
    label("Toque em JOGAR para simular a partida.",50,840,18,Color("#91a4bf"))

    draw_rect(Rect2(0,h-92,w,92),Color("#0f1b2d"))
    label("INÍCIO",25,h-38,17,Color("#2dd4bf"))
    label("ELENCO",w*0.22,h-38,17,Color("#91a4bf"))
    label("TÁTICA",w*0.42,h-38,17,Color("#91a4bf"))
    label("TABELA",w*0.62,h-38,17,Color("#91a4bf"))
    label("CLUBE",w*0.82,h-38,17,Color("#91a4bf"))

func card(r:Rect2):
    var b=StyleBoxFlat.new()
    b.bg_color=Color("#121f33")
    b.border_color=Color("#263b58")
    b.set_border_width_all(2)
    b.set_corner_radius_all(16)
    draw_style_box(b,r)

func stat(r:Rect2,title:String,value:String):
    card(r)
    label(title,r.position.x+18,r.position.y+35,17,Color("#91a4bf"))
    label(value,r.position.x+18,r.position.y+78,25)

func button(r:Rect2,t:String,c:Color):
    var b=StyleBoxFlat.new()
    b.bg_color=Color("#182a42")
    b.border_color=c
    b.set_border_width_all(2)
    b.set_corner_radius_all(14)
    draw_style_box(b,r)
    label(t,r.position.x+35,r.position.y+45,24)

func label(t:String,x:float,y:float,s:int,c:=Color.WHITE):
    draw_string(ThemeDB.fallback_font,Vector2(x,y),t,HORIZONTAL_ALIGNMENT_LEFT,-1,s,c)

func _gui_input(event):
    if (event is InputEventScreenTouch and event.pressed) or (event is InputEventMouseButton and event.pressed):
        var p=event.position
        if Rect2(size.x-280,220,245,100).has_point(p):
            simulate_match()

func simulate_match():
    var home=rng.randi_range(0,3)+2
    var away=rng.randi_range(0,3)
    if tactic=="4-3-3 Posse": home+=1
    if home>away:
        wins+=1
        points+=3
        morale=min(100,morale+4)
    elif home==away:
        draws+=1
        points+=1
        morale=min(100,morale+1)
    else:
        losses+=1
        morale=max(0,morale-4)
    money += 90000-home*10000
    week+=1
    last_result=club+" "+str(home)+" x "+str(away)+" Vale Azul"
    queue_redraw()

func money_text(v:int)->String:
    var s=str(v)
    var out=""
    var n=0
    for i in range(s.length()-1,-1,-1):
        out=s[i]+out
        n+=1
        if n%3==0 and i>0: out="."+out
    return out
