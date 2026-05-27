extends Node



# Shop-related Events
signal shop_relic_bought(relic: Relic, cost: int)
signal shop_card_bought(card: Card, cost: int)
signal shop_exited

#UI signals
signal hit
signal stand
signal double_down
signal split

#from game to UI
signal round_end
