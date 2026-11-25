extends Control

# --- НАЛАШТУВАННЯ TELEGRAM БОТА ТА ADSGRAM ---
const BOT_USERNAME: String = "CodeCapitalGame_bot"
const ADSGRAM_BLOCK_ID: String = "61852"

# --- ЕКОНОМІКА ТА ПРОГРЕС ---
var money: float = 10.0
var total_earned: float = 10.0
var total_clicks: int = 0
var click_power: float = 1.0
var base_passive_income: float = 0.0
var reputation: int = 50
var founder_shares: int = 0
var boost_time_left: float = 0.0
var invites_count: int = 0
var is_ad_playing: bool = false

var upgrades = [
	{"name": "Freelance Script", "cost": 15.0, "income": 1.5, "count": 0},
	{"name": "Junior Developer", "cost": 120.0, "income": 12.0, "count": 0},
	{"name": "AI Trading Bot", "cost": 750.0, "income": 65.0, "count": 0},
	{"name": "Cloud Server Farm", "cost": 4500.0, "income": 380.0, "count": 0},
	{"name": "Neural Network Lab", "cost": 25000.0, "income": 2100.0, "count": 0},
	{"name": "Quantum AI Core", "cost": 150000.0, "income": 14500.0, "count": 0}
]

var tech_researches = [
	{"name": "TECH: Auto-Refactor (2x Clicks)", "cost": 500.0, "type": "click_mult", "val": 2.0, "done": false},
	{"name": "TECH: Cloud Optimization (+25% Income)", "cost": 3500.0, "type": "inc_mult", "val": 1.25, "done": false},
	{"name": "TECH: Neural Overclock (3x Clicks)", "cost": 20000.0, "type": "click_mult", "val": 3.0, "done": false},
	{"name": "TECH: Global AI Monopoly (+50% Income)", "cost": 120000.0, "type": "inc_mult", "val": 1.50, "done": false}
]

var luxury_items = [
	{"name": "Cyber Sports Car", "cost": 5000.0, "bonus": 0.15, "bought": false},
	{"name": "Miami Penthouse", "cost": 35000.0, "bonus": 0.35, "bought": false},
	{"name": "Superyacht 'Byte'", "cost": 200000.0, "bonus": 0.75, "bought": false},
	{"name": "Private AI Island", "cost": 1500000.0, "bonus": 1.50, "bought": false}
]

var achievements = [
	{"id": "first_100", "title": "First Seed Capital", "desc": "Earn $100 total", "reward": 50.0, "unlocked": false},
	{"id": "clicks_50", "title": "Keyboard Warrior", "desc": "Write code 50 times", "reward": 120.0, "unlocked": false},
	{"id": "first_10k", "title": "Startup Founder", "desc": "Reach $10,000 balance", "reward": 1500.0, "unlocked": false},
	{"id": "first_ipo", "title": "Wall Street Legend", "desc": "Complete your first IPO", "reward": 25000.0, "unlocked": false}
]

# --- КРИПТО-БІРЖА ---
var coins = [
	{"ticker": "BTC-X", "name": "BitCore", "price": 100.0, "owned": 0.0, "change": 0.0, "volatility": 0.12, "history": [95.0, 98.0, 96.0, 99.0, 100.0, 100.0]},
	{"ticker": "NEURO", "name": "NeuroAI", "price": 25.0, "owned": 0.0, "change": 0.0, "volatility": 0.25, "history": [22.0, 24.0, 21.0, 23.0, 26.0, 25.0]},
	{"ticker": "MEME", "name": "DogeGPT", "price": 2.0, "owned": 0.0, "change": 0.0, "volatility": 0.55, "history": [1.8, 2.2, 1.5, 1.9, 2.1, 2.0]}
]
var market_timer: float = 0.0
var current_news: String = "MARKET LIVE: Monitoring global AI & crypto feeds..."
var news_trend_ticker: String = ""
var news_trend_dir: float = 0.0

var news_feed = [
	{"text": "INSIDER: Tech giant plans to integrate NeuroAI!", "ticker": "NEURO", "dir": 0.45},
	{"text": "ALERT: Major security breach hits BitCore nodes!", "ticker": "BTC-X", "dir": -0.35},
	{"text": "VIRAL: Billionaire posts a DogeGPT meme!", "ticker": "MEME", "dir": 0.85},
	{"text": "SEC WARNING: Regulators investigating Meme coins!", "ticker": "MEME", "dir": -0.60},
	{"text": "BULL RUN: Institutional funds flowing into BTC-X!", "ticker": "BTC-X", "dir": 0.30},
	{"text": "BUG REPORT: NeuroAI model hallucinates in prod!", "ticker": "NEURO", "dir": -0.30}
]

# --- БІЗНЕС-ПОДІЇ ---
var event_timer: float = 12.0
var active_event = null
var events_pool = [
	{
		"title": "ANGEL INVESTOR OFFER",
		"desc": "A Silicon Valley VC offers instant seed funding or wants to upgrade your coding pipeline.",
		"opt1_text": "Take Cash (+$800)", "opt1_type": "cash", "opt1_val": 800.0,
		"opt2_text": "+30% Click Power", "opt2_type": "click", "opt2_val": 1.30
	},
	{
		"title": "HACKER RANSOMWARE",
		"desc": "Anonymous group locked your test server! Pay 15% of your balance or fight back.",
		"opt1_text": "Pay 15% Ransom", "opt1_type": "pay_pct", "opt1_val": 0.15,
		"opt2_text": "Counter-Hack (50/50)", "opt2_type": "gamble", "opt2_val": 0.50
	},
	{
		"title": "VIRAL TIKTOK REVIEW",
		"desc": "A top tech creator reviewed your AI tool! Traffic is exploding.",
		"opt1_text": "Monetize (+$2,000)", "opt1_type": "cash", "opt1_val": 2000.0,
		"opt2_text": "Boost Reputation (+15%)", "opt2_type": "rep", "opt2_val": 15
	},
	{
		"title": "COMPETITOR BUYOUT OFFER",
		"desc": "A rival startup wants to license your early algorithm.",
		"opt1_text": "Sell License (+$5,000)", "opt1_type": "cash", "opt1_val": 5000.0,
		"opt2_text": "Refuse (+20% Reputation)", "opt2_type": "rep", "opt2_val": 20
	}
]

# --- UI ТА ЗВУК ---
var money_label: Label
var income_label: Label
var boost_btn: Button
var news_label: Label
var work_btn: Button
var tab_containers: Array[Control] = []
var nav_buttons: Array[Button] = []
var upgrade_buttons: Array[Button] = []
var tech_buttons: Array[Button] = []
var coin_labels: Array[Label] = []
var coin_charts: Array[Line2D] = []
var luxury_buttons: Array[Button] = []
var ach_labels: Array[Label] = []
var ipo_btn: Button
var ipo_info_lbl: Label
var invite_btn: Button
var event_panel: PanelContainer
var event_title_lbl: Label
var event_desc_lbl: Label
var event_btn1: Button
var event_btn2: Button
var event_status_lbl: Label
var fx_layer: Control
var save_timer: float = 0.0
var ui_timer: float = 0.0
var sfx_player: AudioStreamPlayer

func _ready():
	setup_audio()
	load_game()
	build_ui()
	init_telegram_webapp()
	update_ui()

func init_telegram_webapp():
	if OS.has_feature("web"):
		JavaScriptBridge.eval("""
			if (window.Telegram && window.Telegram.WebApp) {
				window.Telegram.WebApp.ready();
				window.Telegram.WebApp.expand();
			}
		""")

func show_adsgram_rewarded(reward_type: String) -> void:
	if is_ad_playing:
		return
	var clean_block_id = ADSGRAM_BLOCK_ID.strip_edges()
	if clean_block_id == "":
		show_toast("⚠️ ADSGRAM_BLOCK_ID is not set.")
		return

	is_ad_playing = true
	update_ui()

	if not OS.has_feature("web"):
		is_ad_playing = false
		_apply_ad_reward(reward_type)
		return

	var safe_block_id = clean_block_id.replace("\\", "\\\\").replace("'", "\\'")
	JavaScriptBridge.eval("""
		window.adRewarded = false;
		window.adFinished = false;
		if (window.Adsgram) {
			if (!window.adController || window.adBlockId !== '%s') {
				window.adBlockId = '%s';
				window.adController = window.Adsgram.init({ blockId: '%s' });
			}
			window.adController.show().then((result) => {
				window.adRewarded = true;
				window.adFinished = true;
			}).catch((result) => {
				console.warn('AdsGram status:', result);
				window.adRewarded = false;
				window.adFinished = true;
			});
		} else {
			console.error('AdsGram SDK not loaded');
			window.adFinished = true;
		}
	""" % [safe_block_id, safe_block_id, safe_block_id])

	var safety_timer: float = 0.0
	while not bool(JavaScriptBridge.eval("Boolean(window.adFinished)")):
		await get_tree().create_timer(0.3).timeout
		safety_timer += 0.3
		if safety_timer >= 60.0:
			break

	var rewarded = bool(JavaScriptBridge.eval("Boolean(window.adRewarded)"))
	is_ad_playing = false

	if rewarded:
		_apply_ad_reward(reward_type)
	else:
		show_toast("⚠️ Ad not completed or unavailable right now.")
		update_ui()

func _apply_ad_reward(reward_type: String) -> void:
	if reward_type == "boost":
		boost_time_left = 120.0
		play_tone(950.0, 0.12)
		show_toast("⚡ 2X PROFIT ACTIVATED FOR 120s!")
	elif reward_type == "insider":
		var target_idx = randi() % coins.size()
		var c = coins[target_idx]
		news_trend_ticker = str(c["ticker"])
		news_trend_dir = 0.65
		current_news = "VIP INSIDER SIGNAL: " + news_trend_ticker + " is about to surge +65%!"
		if news_label:
			news_label.text = current_news
		play_tone(950.0, 0.12)
		show_toast("📡 INSIDER PUMP SIGNAL RECEIVED!")
	save_game()
	update_ui()

func setup_audio():
	sfx_player = AudioStreamPlayer.new()
	var gen = AudioStreamGenerator.new()
	gen.mix_rate = 22050
	gen.buffer_length = 0.1
	sfx_player.stream = gen
	sfx_player.volume_db = -10.0
	add_child(sfx_player)

func play_tone(freq: float, duration: float = 0.06):
	if not sfx_player.playing:
		sfx_player.play()
	var playback = sfx_player.get_stream_playback() as AudioStreamGeneratorPlayback
	if playback:
		var samples = int(22050 * duration)
		for i in range(samples):
			var t = float(i) / 22050.0
			var env = 1.0 - (float(i) / max(1, samples))
			var sample = sin(TAU * freq * t) * env * 0.4
			playback.push_frame(Vector2(sample, sample))

func get_total_multiplier() -> float:
	var mult = 1.0 + (founder_shares * 0.5) + (invites_count * 0.10)
	for item in luxury_items:
		if item["bought"]:
			mult += float(item["bonus"])
	for t in tech_researches:
		if t["done"] and t["type"] == "inc_mult":
			mult *= float(t["val"])
	if boost_time_left > 0.0:
		mult *= 2.0
	return mult

func get_effective_passive_income() -> float:
	return base_passive_income * get_total_multiplier()

func get_effective_click_power() -> float:
	var c_mult = 1.0
	for t in tech_researches:
		if t["done"] and t["type"] == "click_mult":
			c_mult *= float(t["val"])
	return click_power * c_mult * get_total_multiplier()

func create_card_style(bg_hex: String, border_hex: String) -> StyleBoxFlat:
	var sb = StyleBoxFlat.new()
	sb.bg_color = Color(bg_hex)
	sb.border_color = Color(border_hex)
	sb.set_border_width_all(2)
	sb.set_corner_radius_all(12)
	sb.set_content_margin_all(10)
	return sb

func build_ui():
	var bg = ColorRect.new()
	bg.color = Color("#090D16")
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(bg)

	var main_margin = MarginContainer.new()
	main_margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	main_margin.add_theme_constant_override("margin_left", 16)
	main_margin.add_theme_constant_override("margin_right", 16)
	main_margin.add_theme_constant_override("margin_top", 20)
	main_margin.add_theme_constant_override("margin_bottom", 16)
	add_child(main_margin)

	var root_vbox = VBoxContainer.new()
	root_vbox.add_theme_constant_override("separation", 12)
	main_margin.add_child(root_vbox)

	# ШАПКА
	var header_panel = PanelContainer.new()
	header_panel.add_theme_stylebox_override("panel", create_card_style("#111827", "#1E293B"))
	root_vbox.add_child(header_panel)

	var header_vbox = VBoxContainer.new()
	header_vbox.add_theme_constant_override("separation", 4)
	header_panel.add_child(header_vbox)

	var top_hbox = HBoxContainer.new()
	header_vbox.add_child(top_hbox)

	var top_bar = Label.new()
	top_bar.text = "CODE & CAPITAL // TELEGRAM EDITION"
	top_bar.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	top_bar.add_theme_font_size_override("font_size", 11)
	top_bar.add_theme_color_override("font_color", Color("#10B981"))
	top_hbox.add_child(top_bar)

	boost_btn = Button.new()
	boost_btn.text = "[AD] 2X PROFIT"
	boost_btn.add_theme_font_size_override("font_size", 11)
	boost_btn.add_theme_stylebox_override("normal", create_card_style("#B45309", "#F59E0B"))
	boost_btn.pressed.connect(_on_ad_boost_pressed)
	top_hbox.add_child(boost_btn)

	money_label = Label.new()
	money_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	money_label.add_theme_font_size_override("font_size", 38)
	money_label.add_theme_color_override("font_color", Color("#F8FAFC"))
	header_vbox.add_child(money_label)

	income_label = Label.new()
	income_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	income_label.add_theme_font_size_override("font_size", 14)
	income_label.add_theme_color_override("font_color", Color("#94A3B8"))
	header_vbox.add_child(income_label)

	var news_panel = PanelContainer.new()
	news_panel.add_theme_stylebox_override("panel", create_card_style("#0F172A", "#0284C7"))
	root_vbox.add_child(news_panel)

	news_label = Label.new()
	news_label.text = current_news
	news_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	news_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	news_label.add_theme_font_size_override("font_size", 12)
	news_label.add_theme_color_override("font_color", Color("#38BDF8"))
	news_panel.add_child(news_label)

	var content_area = Control.new()
	content_area.size_flags_vertical = Control.SIZE_EXPAND_FILL
	root_vbox.add_child(content_area)

	# ВКЛАДКА 0: STARTUP & R&D
	var startup_vbox = VBoxContainer.new()
	startup_vbox.set_anchors_preset(Control.PRESET_FULL_RECT)
	startup_vbox.add_theme_constant_override("separation", 10)
	content_area.add_child(startup_vbox)
	tab_containers.append(startup_vbox)

	work_btn = Button.new()
	work_btn.custom_minimum_size = Vector2(0, 74)
	work_btn.pivot_offset = Vector2(250, 37)
	work_btn.add_theme_font_size_override("font_size", 19)
	work_btn.add_theme_stylebox_override("normal", create_card_style("#059669", "#10B981"))
	work_btn.add_theme_stylebox_override("hover", create_card_style("#10B981", "#34D399"))
	work_btn.add_theme_stylebox_override("pressed", create_card_style("#047857", "#10B981"))
	work_btn.pressed.connect(_on_work_pressed)
	startup_vbox.add_child(work_btn)

	var scroll = ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	startup_vbox.add_child(scroll)

	var shop_list = VBoxContainer.new()
	shop_list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	shop_list.add_theme_constant_override("separation", 8)
	scroll.add_child(shop_list)

	for i in range(upgrades.size()):
		var btn = Button.new()
		btn.custom_minimum_size = Vector2(0, 62)
		btn.add_theme_font_size_override("font_size", 14)
		btn.add_theme_stylebox_override("normal", create_card_style("#1E293B", "#334155"))
		btn.pressed.connect(_on_buy_upgrade.bind(i))
		shop_list.add_child(btn)
		upgrade_buttons.append(btn)

	var tech_header = Label.new()
	tech_header.text = "R&D LAB (ONE-TIME BREAKTHROUGHS)"
	tech_header.add_theme_font_size_override("font_size", 13)
	tech_header.add_theme_color_override("font_color", Color("#A78BFA"))
	shop_list.add_child(tech_header)

	for i in range(tech_researches.size()):
		var t_btn = Button.new()
		t_btn.custom_minimum_size = Vector2(0, 54)
		t_btn.add_theme_font_size_override("font_size", 13)
		t_btn.add_theme_stylebox_override("normal", create_card_style("#2E1065", "#7C3AED"))
		t_btn.pressed.connect(_on_buy_tech.bind(i))
		shop_list.add_child(t_btn)
		tech_buttons.append(t_btn)

	# ВКЛАДКА 1: MARKET
	var market_vbox = VBoxContainer.new()
	market_vbox.set_anchors_preset(Control.PRESET_FULL_RECT)
	market_vbox.add_theme_constant_override("separation", 10)
	market_vbox.visible = false
	content_area.add_child(market_vbox)
	tab_containers.append(market_vbox)

	var insider_ad_btn = Button.new()
	insider_ad_btn.text = "[AD] SCAN INSIDER PUMP SIGNAL"
	insider_ad_btn.custom_minimum_size = Vector2(0, 44)
	insider_ad_btn.add_theme_font_size_override("font_size", 13)
	insider_ad_btn.add_theme_stylebox_override("normal", create_card_style("#4338CA", "#818CF8"))
	insider_ad_btn.pressed.connect(_on_ad_insider_pressed)
	market_vbox.add_child(insider_ad_btn)

	for i in range(coins.size()):
		var c_panel = PanelContainer.new()
		c_panel.add_theme_stylebox_override("panel", create_card_style("#111827", "#334155"))
		market_vbox.add_child(c_panel)

		var c_vbox = VBoxContainer.new()
		c_vbox.add_theme_constant_override("separation", 6)
		c_panel.add_child(c_vbox)

		var top_row = HBoxContainer.new()
		c_vbox.add_child(top_row)

		var info_lbl = Label.new()
		info_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		info_lbl.add_theme_font_size_override("font_size", 14)
		top_row.add_child(info_lbl)
		coin_labels.append(info_lbl)

		var chart_box = Control.new()
		chart_box.custom_minimum_size = Vector2(110, 36)
		top_row.add_child(chart_box)

		var line = Line2D.new()
		line.width = 2.5
		line.default_color = Color("#10B981")
		chart_box.add_child(line)
		coin_charts.append(line)

		var btn_hbox = HBoxContainer.new()
		btn_hbox.add_theme_constant_override("separation", 8)
		c_vbox.add_child(btn_hbox)

		var buy_btn = Button.new()
		buy_btn.text = "BUY 1"
		buy_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		buy_btn.custom_minimum_size = Vector2(0, 36)
		buy_btn.add_theme_stylebox_override("normal", create_card_style("#065F46", "#10B981"))
		buy_btn.pressed.connect(_on_buy_coin.bind(i, 1.0))
		btn_hbox.add_child(buy_btn)

		var buy_max_btn = Button.new()
		buy_max_btn.text = "BUY MAX"
		buy_max_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		buy_max_btn.custom_minimum_size = Vector2(0, 36)
		buy_max_btn.add_theme_stylebox_override("normal", create_card_style("#047857", "#34D399"))
		buy_max_btn.pressed.connect(_on_buy_coin_max.bind(i))
		btn_hbox.add_child(buy_max_btn)

		var sell_btn = Button.new()
		sell_btn.text = "SELL ALL"
		sell_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		sell_btn.custom_minimum_size = Vector2(0, 36)
		sell_btn.add_theme_stylebox_override("normal", create_card_style("#991B1B", "#EF4444"))
		sell_btn.pressed.connect(_on_sell_coin_all.bind(i))
		btn_hbox.add_child(sell_btn)

	# ВКЛАДКА 2: EVENTS
	var events_vbox = VBoxContainer.new()
	events_vbox.set_anchors_preset(Control.PRESET_FULL_RECT)
	events_vbox.add_theme_constant_override("separation", 14)
	events_vbox.visible = false
	content_area.add_child(events_vbox)
	tab_containers.append(events_vbox)

	event_status_lbl = Label.new()
	event_status_lbl.text = "No urgent messages. Scanning network..."
	event_status_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	event_status_lbl.add_theme_font_size_override("font_size", 15)
	event_status_lbl.add_theme_color_override("font_color", Color("#94A3B8"))
	events_vbox.add_child(event_status_lbl)

	event_panel = PanelContainer.new()
	event_panel.add_theme_stylebox_override("panel", create_card_style("#1E1B4B", "#6366F1"))
	event_panel.visible = false
	events_vbox.add_child(event_panel)

	var ev_inner = VBoxContainer.new()
	ev_inner.add_theme_constant_override("separation", 12)
	event_panel.add_child(ev_inner)

	event_title_lbl = Label.new()
	event_title_lbl.add_theme_font_size_override("font_size", 18)
	event_title_lbl.add_theme_color_override("font_color", Color("#A5B4FC"))
	ev_inner.add_child(event_title_lbl)

	event_desc_lbl = Label.new()
	event_desc_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	event_desc_lbl.add_theme_font_size_override("font_size", 15)
	ev_inner.add_child(event_desc_lbl)

	event_btn1 = Button.new()
	event_btn1.custom_minimum_size = Vector2(0, 48)
	event_btn1.pressed.connect(_on_event_choice.bind(1))
	ev_inner.add_child(event_btn1)

	event_btn2 = Button.new()
	event_btn2.custom_minimum_size = Vector2(0, 48)
	event_btn2.pressed.connect(_on_event_choice.bind(2))
	ev_inner.add_child(event_btn2)

	# ВКЛАДКА 3: EMPIRE, INVITES & IPO
	var emp_scroll = ScrollContainer.new()
	emp_scroll.set_anchors_preset(Control.PRESET_FULL_RECT)
	emp_scroll.visible = false
	content_area.add_child(emp_scroll)
	tab_containers.append(emp_scroll)

	var empire_vbox = VBoxContainer.new()
	empire_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	empire_vbox.add_theme_constant_override("separation", 10)
	emp_scroll.add_child(empire_vbox)

	# ВІРУСНА РЕФЕРАЛКА TELEGRAM
	invite_btn = Button.new()
	invite_btn.text = "🚀 INVITE FRIEND (+$5,000 & +10% PROFIT)"
	invite_btn.custom_minimum_size = Vector2(0, 52)
	invite_btn.add_theme_font_size_override("font_size", 14)
	invite_btn.add_theme_stylebox_override("normal", create_card_style("#0284C7", "#38BDF8"))
	invite_btn.pressed.connect(_on_invite_friend_pressed)
	empire_vbox.add_child(invite_btn)

	var ipo_panel = PanelContainer.new()
	ipo_panel.add_theme_stylebox_override("panel", create_card_style("#1E1B4B", "#F59E0B"))
	empire_vbox.add_child(ipo_panel)

	var ipo_inner = VBoxContainer.new()
	ipo_inner.add_theme_constant_override("separation", 8)
	ipo_panel.add_child(ipo_inner)

	ipo_info_lbl = Label.new()
	ipo_info_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	ipo_info_lbl.add_theme_font_size_override("font_size", 13)
	ipo_info_lbl.add_theme_color_override("font_color", Color("#FDE68A"))
	ipo_inner.add_child(ipo_info_lbl)

	ipo_btn = Button.new()
	ipo_btn.custom_minimum_size = Vector2(0, 45)
	ipo_btn.add_theme_stylebox_override("normal", create_card_style("#B45309", "#FBBF24"))
	ipo_btn.pressed.connect(_on_ipo_pressed)
	ipo_inner.add_child(ipo_btn)

	var lux_title = Label.new()
	lux_title.text = "BILLIONAIRE LIFESTYLE (PERMANENT MULTIPLIERS)"
	lux_title.add_theme_font_size_override("font_size", 13)
	lux_title.add_theme_color_override("font_color", Color("#38BDF8"))
	empire_vbox.add_child(lux_title)

	for i in range(luxury_items.size()):
		var l_btn = Button.new()
		l_btn.custom_minimum_size = Vector2(0, 48)
		l_btn.add_theme_font_size_override("font_size", 14)
		l_btn.add_theme_stylebox_override("normal", create_card_style("#1E293B", "#475569"))
		l_btn.pressed.connect(_on_buy_luxury.bind(i))
		empire_vbox.add_child(l_btn)
		luxury_buttons.append(l_btn)

	var ach_title = Label.new()
	ach_title.text = "FOUNDER ACHIEVEMENTS"
	ach_title.add_theme_font_size_override("font_size", 13)
	ach_title.add_theme_color_override("font_color", Color("#34D399"))
	empire_vbox.add_child(ach_title)

	for i in range(achievements.size()):
		var a_panel = PanelContainer.new()
		a_panel.add_theme_stylebox_override("panel", create_card_style("#0F172A", "#1E293B"))
		empire_vbox.add_child(a_panel)
		var a_lbl = Label.new()
		a_lbl.add_theme_font_size_override("font_size", 13)
		a_panel.add_child(a_lbl)
		ach_labels.append(a_lbl)

	# НИЖНЯ НАВІГАЦІЯ
	var nav_hbox = HBoxContainer.new()
	nav_hbox.add_theme_constant_override("separation", 6)
	root_vbox.add_child(nav_hbox)

	var tab_names = ["STARTUP", "MARKET", "EVENTS", "EMPIRE"]
	for i in range(tab_names.size()):
		var t_btn = Button.new()
		t_btn.text = tab_names[i]
		t_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		t_btn.custom_minimum_size = Vector2(0, 52)
		t_btn.add_theme_font_size_override("font_size", 13)
		t_btn.add_theme_stylebox_override("normal", create_card_style("#1E293B", "#475569"))
		t_btn.pressed.connect(_switch_tab.bind(i))
		nav_hbox.add_child(t_btn)
		nav_buttons.append(t_btn)

	# ШАР ЕФЕКТІВ
	fx_layer = Control.new()
	fx_layer.set_anchors_preset(Control.PRESET_FULL_RECT)
	fx_layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(fx_layer)

func _on_invite_friend_pressed():
	var share_text = "I just built an AI Crypto Empire! Beat my net worth:"
	var encoded_text = share_text.uri_encode()
	var bot_link = ("https://t.me/" + BOT_USERNAME + "?start=ref").uri_encode()
	var share_url = "https://t.me/share/url?url=" + bot_link + "&text=" + encoded_text
	if OS.has_feature("web"):
		var safe_url = share_url.replace("\\", "\\\\").replace("'", "\\'")
		JavaScriptBridge.eval("""
			if (window.Telegram && window.Telegram.WebApp && typeof window.Telegram.WebApp.openTelegramLink === 'function') {
				window.Telegram.WebApp.openTelegramLink('%s');
			} else {
				window.open('%s', '_blank');
			}
		""" % [safe_url, safe_url])
	else:
		OS.shell_open(share_url)
	invites_count += 1
	add_money(5000.0)
	play_tone(1150.0, 0.14)
	show_toast("🚀 REFERRAL BONUS: +$5,000 & +10% PROFIT!")
	save_game()
	update_ui()

func add_money(amount: float):
	money += amount
	if amount > 0.0:
		total_earned += amount
	check_achievements()

func check_achievements():
	for a in achievements:
		if a["unlocked"]:
			continue
		var done = false
		if a["id"] == "first_100" and total_earned >= 100.0:
			done = true
		elif a["id"] == "clicks_50" and total_clicks >= 50:
			done = true
		elif a["id"] == "first_10k" and money >= 10000.0:
			done = true
		elif a["id"] == "first_ipo" and founder_shares >= 1:
			done = true

		if done:
			a["unlocked"] = true
			money += float(a["reward"])
			play_tone(1320.0, 0.15)
			show_toast("🏆 ACHIEVEMENT: " + str(a["title"]) + " (+$" + format_number(float(a["reward"])) + ")")

func show_toast(msg: String):
	var banner = PanelContainer.new()
	banner.add_theme_stylebox_override("panel", create_card_style("#064E3B", "#10B981"))
	banner.position = Vector2(30, 125)
	banner.custom_minimum_size = Vector2(480, 44)
	fx_layer.add_child(banner)

	var lbl = Label.new()
	lbl.text = msg
	lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	lbl.add_theme_font_size_override("font_size", 14)
	lbl.add_theme_color_override("font_color", Color("#ECFDF5"))
	banner.add_child(lbl)

	var tw = create_tween()
	tw.tween_interval(2.5)
	tw.tween_property(banner, "modulate:a", 0.0, 0.5)
	tw.tween_callback(banner.queue_free)

func spawn_floating_text(amount: float):
	var lbl = Label.new()
	lbl.text = "+$" + format_number(amount)
	lbl.add_theme_font_size_override("font_size", 22)
	lbl.add_theme_color_override("font_color", Color("#34D399"))
	lbl.position = Vector2(randf_range(160.0, 340.0), 230.0)
	fx_layer.add_child(lbl)

	var tw = create_tween()
	tw.set_parallel(true)
	tw.tween_property(lbl, "position:y", 155.0, 0.65).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tw.tween_property(lbl, "modulate:a", 0.0, 0.65)
	tw.chain().tween_callback(lbl.queue_free)

func _switch_tab(index: int):
	play_tone(520.0, 0.04)
	for i in range(tab_containers.size()):
		tab_containers[i].visible = (i == index)
	update_ui()

func _process(delta):
	var need_ui_refresh: bool = false

	if boost_time_left > 0.0:
		boost_time_left = max(0.0, boost_time_left - delta)
		need_ui_refresh = true

	var eff_income = get_effective_passive_income()
	if eff_income > 0.0:
		add_money(eff_income * delta)
		need_ui_refresh = true

	market_timer += delta
	if market_timer >= 5.0:
		market_timer = 0.0
		update_market()
		need_ui_refresh = true

	if active_event == null:
		event_timer -= delta
		if event_timer <= 0.0:
			trigger_random_event()
			event_timer = randf_range(25.0, 45.0)
			need_ui_refresh = true

	save_timer += delta
	if save_timer >= 10.0:
		save_timer = 0.0
		save_game()

	ui_timer += delta
	if need_ui_refresh and ui_timer >= 0.1:
		ui_timer = 0.0
		update_ui()

func _on_work_pressed():
	total_clicks += 1
	var gain = get_effective_click_power()
	add_money(gain)
	play_tone(680.0, 0.05)
	spawn_floating_text(gain)
	var tw = create_tween()
	tw.tween_property(work_btn, "scale", Vector2(0.96, 0.96), 0.04)
	tw.tween_property(work_btn, "scale", Vector2(1.0, 1.0), 0.06)
	update_ui()

func _on_buy_upgrade(index: int):
	var item = upgrades[index]
	var cost_val = float(item["cost"])
	if money >= cost_val:
		money -= cost_val
		item["count"] = int(item["count"]) + 1
		base_passive_income += float(item["income"])
		item["cost"] = round(cost_val * 1.18 * 100.0) / 100.0
		click_power += float(item["income"]) * 0.12
		play_tone(880.0, 0.08)
		save_game()
		update_ui()

func _on_buy_tech(index: int):
	var t = tech_researches[index]
	var cost_val = float(t["cost"])
	if not t["done"] and money >= cost_val:
		money -= cost_val
		t["done"] = true
		play_tone(1100.0, 0.12)
		show_toast("🔬 RESEARCHED: " + str(t["name"]))
		save_game()
		update_ui()

func _on_buy_luxury(index: int):
	var item = luxury_items[index]
	var cost_val = float(item["cost"])
	if not item["bought"] and money >= cost_val:
		money -= cost_val
		item["bought"] = true
		play_tone(1040.0, 0.12)
		save_game()
		update_ui()

func _on_ipo_pressed():
	if money >= 1000000.0:
		var earned_shares = int(floor(money / 1000000.0))
		founder_shares += earned_shares
		money = 50.0
		click_power = 1.0
		base_passive_income = 0.0
		for u in upgrades:
			u["count"] = 0
		upgrades[0]["cost"] = 15.0
		upgrades[1]["cost"] = 120.0
		upgrades[2]["cost"] = 750.0
		upgrades[3]["cost"] = 4500.0
		upgrades[4]["cost"] = 25000.0
		upgrades[5]["cost"] = 150000.0
		check_achievements()
		play_tone(1200.0, 0.18)
		save_game()
		update_ui()

func _on_ad_boost_pressed():
	show_adsgram_rewarded("boost")

func _on_ad_insider_pressed():
	show_adsgram_rewarded("insider")

func update_market():
	if randf() < 0.45 and news_trend_dir != 0.65:
		var news = news_feed[randi() % news_feed.size()]
		current_news = str(news["text"])
		news_trend_ticker = str(news["ticker"])
		news_trend_dir = float(news["dir"])
		if news_label:
			news_label.text = current_news
	else:
		news_trend_ticker = ""
		news_trend_dir = 0.0

	for c in coins:
		var vol = float(c["volatility"])
		var pct_change = randf_range(-vol, vol)
		if str(c["ticker"]) == news_trend_ticker:
			pct_change += news_trend_dir

		var old_price = float(c["price"])
		c["price"] = max(0.5, old_price * (1.0 + pct_change))
		c["change"] = ((float(c["price"]) - old_price) / max(0.0001, old_price)) * 100.0

		var hist: Array = c.get("history", [])
		hist.append(float(c["price"]))
		if hist.size() > 6:
			hist.pop_front()
		c["history"] = hist

func _on_buy_coin(index: int, amount: float):
	var c = coins[index]
	var total_cost = float(c["price"]) * amount
	if money >= total_cost:
		money -= total_cost
		c["owned"] = float(c["owned"]) + amount
		play_tone(740.0, 0.05)
		update_ui()

func _on_buy_coin_max(index: int):
	var c = coins[index]
	var price_val = float(c["price"])
	if price_val <= 0.0:
		return
	var max_amt = floor(money / price_val)
	if max_amt >= 1.0:
		money -= max_amt * price_val
		c["owned"] = float(c["owned"]) + max_amt
		play_tone(780.0, 0.06)
		update_ui()

func _on_sell_coin_all(index: int):
	var c = coins[index]
	var owned_val = float(c["owned"])
	if owned_val > 0.0:
		add_money(owned_val * float(c["price"]))
		c["owned"] = 0.0
		play_tone(920.0, 0.08)
		update_ui()

func trigger_random_event():
	active_event = events_pool[randi() % events_pool.size()]
	event_title_lbl.text = "⚡ " + str(active_event["title"])
	event_desc_lbl.text = str(active_event["desc"])
	event_btn1.text = str(active_event["opt1_text"])
	event_btn2.text = str(active_event["opt2_text"])
	event_panel.visible = true
	event_status_lbl.text = "ACTION REQUIRED! Check the offer below:"
	event_status_lbl.add_theme_color_override("font_color", Color("#FBBF24"))
	play_tone(440.0, 0.12)

func _on_event_choice(choice: int):
	if active_event == null:
		return
	var prefix = "opt1_" if choice == 1 else "opt2_"
	var t = str(active_event[prefix + "type"])
	var v = float(active_event[prefix + "val"])

	if t == "cash":
		add_money(v)
	elif t == "click":
		click_power *= v
	elif t == "pay_pct":
		money *= (1.0 - v)
	elif t == "gamble":
		if randf() < 0.5:
			add_money(1500.0)
		else:
			money *= 0.75
	elif t == "rep":
		reputation = int(clamp(reputation + v, 0, 100))

	active_event = null
	event_panel.visible = false
	event_status_lbl.text = "Decision processed. Scanning network..."
	event_status_lbl.add_theme_color_override("font_color", Color("#94A3B8"))
	play_tone(660.0, 0.07)
	save_game()
	update_ui()

func format_pct(val: float) -> String:
	var sign_str = "+" if val >= 0.0 else "-"
	return sign_str + "%.1f%%" % abs(val)

func update_ui():
	money_label.text = "$" + format_number(money)
	var mult = get_total_multiplier()
	var inc_str = format_number(get_effective_passive_income())
	var mult_str = "%.2f" % mult
	income_label.text = "$" + inc_str + "/s  |  Mult: x" + mult_str + "  |  Rep: " + str(reputation) + "%"
	work_btn.text = "WRITE CODE (+$" + format_number(get_effective_click_power()) + ")"

	if boost_time_left > 0.0:
		boost_btn.text = "2X ACTIVE (" + str(int(ceil(boost_time_left))) + "s)"
		boost_btn.disabled = true
	else:
		boost_btn.text = "[AD] 2X PROFIT"
		boost_btn.disabled = is_ad_playing

	nav_buttons[2].text = "EVENTS [!]" if active_event != null else "EVENTS"
	invite_btn.text = "🚀 INVITE FRIEND (+$5K & +10% Mult) [" + str(invites_count) + "]"

	for i in range(upgrades.size()):
		var item = upgrades[i]
		var btn = upgrade_buttons[i]
		var lvl = int(item["count"])
		var inc_val = format_number(float(item["income"]) * mult)
		var cost_val = format_number(float(item["cost"]))
		btn.text = str(item["name"]) + " [Lvl " + str(lvl) + "]\n+$" + inc_val + "/sec  |  Cost: $" + cost_val
		btn.disabled = money < float(item["cost"])

	for i in range(tech_researches.size()):
		var t = tech_researches[i]
		var btn = tech_buttons[i]
		if t["done"]:
			btn.text = "✓ " + str(t["name"]) + " [ACTIVE]"
			btn.disabled = true
		else:
			btn.text = str(t["name"]) + " — Cost: $" + format_number(float(t["cost"]))
			btn.disabled = money < float(t["cost"])

	for i in range(coins.size()):
		var c = coins[i]
		var chg = float(c["change"])
		var trend_arrow = "▲" if chg >= 0.0 else "▼"
		var price_str = format_number(float(c["price"]))
		var pct_str = format_pct(chg)
		var owned_num = float(c["owned"])
		var owned_val_str = format_number(owned_num * float(c["price"]))
		coin_labels[i].text = trend_arrow + " " + str(c["ticker"]) + " — $" + price_str + " (" + pct_str + ")\nOwned: " + str(int(owned_num)) + " ($" + owned_val_str + ")"

		var line = coin_charts[i]
		var hist: Array = c.get("history", [])
		if hist.size() >= 2:
			line.clear_points()
			var min_p = float(hist.min())
			var max_p = float(hist.max())
			var span = max(0.01, max_p - min_p)
			for idx in range(hist.size()):
				var px = (float(idx) / float(hist.size() - 1)) * 105.0
				var py = 32.0 - ((float(hist[idx]) - min_p) / span) * 28.0
				line.add_point(Vector2(px, py))
			line.default_color = Color("#10B981") if chg >= 0.0 else Color("#EF4444")

	for i in range(luxury_items.size()):
		var l = luxury_items[i]
		var btn = luxury_buttons[i]
		var bonus_pct = int(round(float(l["bonus"]) * 100.0))
		if l["bought"]:
			btn.text = "✓ " + str(l["name"]) + " (+" + str(bonus_pct) + "% Profit) — OWNED"
			btn.disabled = true
		else:
			btn.text = str(l["name"]) + " (+" + str(bonus_pct) + "% Profit) — $" + format_number(float(l["cost"]))
			btn.disabled = money < float(l["cost"])

	for i in range(achievements.size()):
		var a = achievements[i]
		var status = "🏆 UNLOCKED" if a["unlocked"] else "🔒 Reward: $" + format_number(float(a["reward"]))
		ach_labels[i].text = str(a["title"]) + " (" + str(a["desc"]) + ") — " + status
		ach_labels[i].add_theme_color_override("font_color", Color("#34D399") if a["unlocked"] else Color("#94A3B8"))

	var potential_shares = int(floor(money / 1000000.0))
	ipo_info_lbl.text = "FOUNDER SHARES: " + str(founder_shares) + " (+" + str(founder_shares * 50) + "% Permanent Bonus)\nReach $1.00M to launch IPO and claim +" + str(potential_shares) + " new shares!"
	ipo_btn.text = "LAUNCH IPO (+" + str(potential_shares) + " SHARES)" if potential_shares >= 1 else "NEED $1.00M FOR IPO"
	ipo_btn.disabled = potential_shares < 1

func format_number(num: float) -> String:
	var abs_num = abs(num)
	var sign = "-" if num < 0.0 else ""
	if abs_num >= 1e12:
		return sign + ("%.2f" % (abs_num / 1e12)) + "T"
	elif abs_num >= 1e9:
		return sign + ("%.2f" % (abs_num / 1e9)) + "B"
	elif abs_num >= 1e6:
		return sign + ("%.2f" % (abs_num / 1e6)) + "M"
	elif abs_num >= 1e3:
		return sign + ("%.2f" % (abs_num / 1e3)) + "K"
	else:
		return sign + ("%.2f" % abs_num)

func save_game():
	var data = {
		"money": money,
		"total_earned": total_earned,
		"total_clicks": total_clicks,
		"click_power": click_power,
		"base_passive_income": base_passive_income,
		"reputation": reputation,
		"founder_shares": founder_shares,
		"invites_count": invites_count,
		"upgrades": upgrades,
		"tech_researches": tech_researches,
		"luxury_items": luxury_items,
		"achievements": achievements,
		"coins": coins,
		"last_time": Time.get_unix_time_from_system()
	}
	var file = FileAccess.open("user://savegame.json", FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(data))

func load_game():
	if not FileAccess.file_exists("user://savegame.json"):
		return
	var file = FileAccess.open("user://savegame.json", FileAccess.READ)
	if not file:
		return
	var data = JSON.parse_string(file.get_as_text())
	if typeof(data) != TYPE_DICTIONARY:
		return
	money = float(data.get("money", money))
	total_earned = float(data.get("total_earned", total_earned))
	total_clicks = int(data.get("total_clicks", total_clicks))
	click_power = float(data.get("click_power", click_power))
	base_passive_income = float(data.get("base_passive_income", base_passive_income))
	reputation = int(data.get("reputation", reputation))
	founder_shares = int(data.get("founder_shares", founder_shares))
	invites_count = int(data.get("invites_count", invites_count))
	if data.has("upgrades") and typeof(data["upgrades"]) == TYPE_ARRAY:
		upgrades = data["upgrades"]
	if data.has("tech_researches") and typeof(data["tech_researches"]) == TYPE_ARRAY:
		tech_researches = data["tech_researches"]
	if data.has("luxury_items") and typeof(data["luxury_items"]) == TYPE_ARRAY:
		luxury_items = data["luxury_items"]
	if data.has("achievements") and typeof(data["achievements"]) == TYPE_ARRAY:
		achievements = data["achievements"]
	if data.has("coins") and typeof(data["coins"]) == TYPE_ARRAY:
		coins = data["coins"]
