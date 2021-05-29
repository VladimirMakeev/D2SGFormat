meta:
  id: sg
  title: Disciples 2 scenario file
  application: Disciples 2 (v3.01)
  file-extension: sg
  license: GPL-3.0-or-later
  ks-version: 0.8
  encoding: cp1251
  endian: le
doc: |
  SG is used by [Disciples 2](https://en.wikipedia.org/wiki/Disciples_II:_Dark_Prophecy) game for scenario maps and saves.
  
  Written and tested by Vladimir Makeev, 2019-2020

seq:
  - id: header
    type: header
  - id: total
    type: int_record('SxxxOBxxxx')
  - id: objects
    type: scenario_object
    repeat: expr
    repeat-expr: total.value

types:
  header:
    seq:
      - id: signature
        type: strz
        size: 10
      - id: data
        type:
          switch-on: signature
          cases:
            '"D2EESFISIG"': d2ee_header
            '"MidFile"': midfile_header
  d2ee_header:
    seq:
      - id: zeroes
        type: u2
      - id: ones
        type: u4
      - id: size
        type: u4
        doc: |
          Header size.
          Can not be greater than 2920 bytes, according to the game code
      - id: unknown1
        contents: [1, 0, 0, 0]
        doc: Must be 1 according to the game code
      - id: unknown2
        contents: [0x23, 0, 0, 0]
        doc: Must be 0x23 (35) according to the game code
      - id: unknown3
        contents: [0, 0, 0, 0]
      - id: scenario_id
        type: strz
        size: 11
      - id: scenario_description
        type: strz
        size: 256
      - id: designer_name
        type: strz
        size: 21
      - id: official_map
        type: u1
        doc: |
          1 means this map is made by 'Strategy First', 0 - 'Third Party'
          ScenarioEditor always set this to 0 when entering objectives menu
      - id: quest_name
        type: strz
        size: 256
      - id: map_size
        type: u4
        doc: This value is shown in preview while selecting scenario to load
      - id: difficulty
        type: u4
        doc: Difficulty value, same as ID in Ldiff.dbf
      - id: turn_number
        type: u4
      - id: unknown4
        type: u4
      - id: campaign_id
        type: str
        size: 11
      - id: sugg_lvl
        type: u4
        doc: Suggested leader level. Scenario Editor set it to the same value as in 'scenario_info.sugg_lvl'
      - id: unknown5
        size: 1
      - id: default_player_name
        type: strz
        size: 256
        doc: Game allows to enter only 15 characters upon starting a scenario
      - id: race
        type: u4
        doc: Race value, same as ID in Lrace.dbf
      - id: unknown6
        size: 815
      - id: unknown_data
        type: u4
      - id: prng_values
        type: u4
        repeat: expr
        repeat-expr: 250
        doc: Values used for pseudo-random number generation
      - id: padding_size
        type: u4
      - id: total_races
        type: u4
        doc: |
          Total races in scenario, including neutrals.
          This information is shown in scenario preview.
      - id: races
        type: race_info
        repeat: expr
        repeat-expr: total_races
      - id: padding
        type: u1
        repeat: expr
        repeat-expr: padding_size
  midfile_header:
    seq:
      - id: zeroes
        size: 6
      - id: version
        type: u2
      - id: unknown
        size: 2725
  race_info:
    seq:
      - id: race_id
        type: u4
        doc: Id encoded the same way as in 'scenario_info.player_' fields
      - id: unknown
        size: 36
  string_record:
    params:
      - id: name_value
        type: str
    seq:
      - id: name
        type: str
        size: name_value.length
      - id: length
        type: u4
        doc: Length of string data, including trailing zero
      - id: string
        type: strz
        size: length
  int_record:
    params:
      - id: name_value
        type: str
    seq:
      - id: name
        type: str
        size: name_value.length
      - id: value
        type: u4
  bool_record:
    params:
      - id: name_value
        type: str
    seq:
      - id: name
        type: str
        size: name_value.length
      - id: value
        type: u1
  currency:
    seq:
      - id: type
        type: u1
      - id: amount_str
        type: str
        size: 4
    instances:
      amount:
        value: amount_str.to_i
    doc: Represents single currency type such as gold or mana
  bank_record:
    params:
      - id: name_value
        type: str
    seq:
      - id: name
        type: str
        size: name_value.length
      - id: length
        type: u4
      - id: gold
        type: currency
      - id: colon1
        contents: ':'
      - id: infernal_mana
        type: currency
        doc: Associated with and primarily used by Legions of the Damned
      - id: colon2
        contents: ':'
      - id: life_mana
        type: currency
        doc: Associated with and primarily used by Empire
      - id: colon3
        contents: ':'
      - id: death_mana
        type: currency
        doc: Associated with and primarily used by Undead Hordes
      - id: colon4
        contents: ':'
      - id: runic_mana
        type: currency
        doc: Associated with and primarily used by Mountain Clans
      - id: colon5
        contents: ':'
        if: _root.header.signature == 'D2EESFISIG'
      - id: grove_mana
        type: currency
        if: _root.header.signature == 'D2EESFISIG'
        doc: Associated with and primarily used by Elven alliance
      - id: terminator
        type: u1
    doc: Represents ingame currency
  position:
    seq:
      - id: x
        type: int_record('POS_X')
      - id: y
        type: int_record('POS_Y')
    doc: Represents map coordinates
  size:
    seq:
      - id: x
        type: int_record('SIZE_X')
      - id: y
        type: int_record('SIZE_Y')
  begobject:
    seq:
      - id: value
        contents: ['BEGOBJECT', 0]
  endobject:
    seq:
      - id: value
        contents: ['ENDOBJECT', 0]
  single_id:
    seq:
      - id: id
        type: int_record('XXXxxxXXXx') # 10
  double_id:
    seq:
      - id: id1
        type: int_record('XXXxxxXXXx') # 10
      - id: id2
        type: int_record('XXXxxxXXXx') # 10
  mid_spell_effect_item:
    seq:
      - id: unit_id
        type: string_record('UNIT_ID')
      - id: origin_id
        type: string_record('ORIGIN_ID')
      - id: modif_id
        type: string_record('MODIF_ID')
      - id: caster_id
        type: string_record('CASTER_ID')
      - id: turn_stop
        type: int_record('TURN_STOP')
  mid_spell_effects:
    seq:
      - id: count
        type: int_record('XXXxxxXXXx')
      - id: items
        type: mid_spell_effect_item
        repeat: expr
        repeat-expr: count.value
  mid_spell_cast_item:
    seq:
      - id: player_id
        type: string_record('PLAYER_ID')
      - id: origin
        type: string_record('ORIGIN')
      - id: turn_stop
        type: int_record('TURN_STOP')
  mid_spell_cast:
    seq:
      - id: count
        type: int_record('XXXxxxXXXx')
      - id: items
        type: mid_spell_cast_item
        repeat: expr
        repeat-expr: count.value
      - id: unknown
        type: int_record('XXXxxxXXXx')
  scenario_info:
    seq:
      - id: info_id
        type: string_record('INFO_ID')
      - id: campaign
        type: string_record('CAMPAIGN')
      - id: source_m
        type: bool_record('SOURCE_M')
      - id: qty_cities
        type: int_record('QTY_CITIES')
      - id: name
        type: string_record('NAME')
      - id: desc
        type: string_record('DESC')
      - id: briefing
        type: string_record('BRIEFING')
      - id: debunkw
        type: string_record('DEBUNKW')
      - id: debunkw2
        type: string_record('DEBUNKW2')
        if: (_root.header.signature == 'D2EESFISIG')
          or (_root.header.data.as<midfile_header>.version == 35)
      - id: debunkw3
        type: string_record('DEBUNKW3')
        if: (_root.header.signature == 'D2EESFISIG')
          or (_root.header.data.as<midfile_header>.version == 35)
      - id: debunkw4
        type: string_record('DEBUNKW4')
        if: (_root.header.signature == 'D2EESFISIG')
          or (_root.header.data.as<midfile_header>.version == 35)
      - id: debunkw5
        type: string_record('DEBUNKW5')
        if: (_root.header.signature == 'D2EESFISIG')
          or (_root.header.data.as<midfile_header>.version == 35)
      - id: debunkl
        type: string_record('DEBUNKL')
      - id: brieflong1
        type: string_record('BRIEFLONG1')
      - id: brieflong2
        type: string_record('BRIEFLONG2')
      - id: brieflong3
        type: string_record('BRIEFLONG3')
      - id: brieflong4
        type: string_record('BRIEFLONG4')
      - id: brieflong5
        type: string_record('BRIEFLONG5')
      - id: o
        type: bool_record('O')
      - id: cur_turn
        type: int_record('CUR_TURN')
      - id: max_unit
        type: int_record('MAX_UNIT')
      - id: max_spell
        type: int_record('MAX_SPELL')
      - id: max_leader
        type: int_record('MAX_LEADER')
      - id: max_city
        type: int_record('MAX_CITY')
      - id: map_size
        type: int_record('MAP_SIZE')
      - id: diffscen
        type: int_record('DIFFSCEN')
      - id: diffgame
        type: int_record('DIFFGAME')
      - id: creator
        type: string_record('CREATOR')
      - id: players
        repeat: expr
        repeat-expr: 13
        type:
          switch-on: _index
          cases:
            _: int_record('PLAYER_N')
            9: int_record('PLAYER_NN')
            10: int_record('PLAYER_NN')
            11: int_record('PLAYER_NN')
            12: int_record('PLAYER_NN')
      - id: sugg_lvl
        type: int_record('SUGG_LVL')
      - id: map_seed
        type: int_record('MAP_SEED')
  mountains_entry:
    seq:
      - id: id_mount
        type: int_record('ID_MOUNT')
      - id: size
        type: size
      - id: position
        type: position
      - id: image
        type: int_record('IMAGE')
      - id: race
        type: int_record('RACE')
  mid_mountains:
    seq:
      - id: mountains_count
        type: int_record('XXXxxxXXXx')
      - id: mountains
        type: mountains_entry
        repeat: expr
        repeat-expr: mountains_count.value
  mid_player_exmap_record:
    seq:
      - id: id
        type: string_record('EXMAPIDx')
      - id: turn
        type: string_record('EXMAPTURNx')
  mid_player:
    seq:
      - id: player_id
        type: string_record('PLAYER_ID')
      - id: name_txt
        type: string_record('NAME_TXT')
      - id: desc_txt
        type: string_record('DESC_TXT')
      - id: lord_id
        type: string_record('LORD_ID')
      - id: race_id
        type: string_record('RACE_ID')
      - id: fog_id
        type: string_record('FOG_ID')
      - id: known_id
        type: string_record('KNOWN_ID')
      - id: builds_id
        type: string_record('BUILDS_ID')
      - id: face
        type: int_record('FACE')
      - id: qty_breaks
        type: int_record('QTY_BREAKS')
      - id: bank
        type: bank_record('BANK')
      - id: is_human
        type: bool_record('IS_HUMAN')
      - id: spell_bank
        type: bank_record('SPELL_BANK')
      - id: attitude
        type: int_record('ATTITUDE')
      - id: resear_t
        type: int_record('RESEAR_T')
      - id: constr_t
        type: int_record('CONSTR_T')
      - id: spies
        type: string_record('SPY_N')
        repeat: expr
        repeat-expr: 3
      - id: capt_by
        type: string_record('CAPT_BY')
      - id: alwaysai
        type: bool_record('ALWAYSAI')
        if: _root.header.signature == 'D2EESFISIG'
      - id: exmap_records
        type: mid_player_exmap_record
        repeat: expr
        repeat-expr: 3
        if: _root.header.signature == 'D2EESFISIG'
  mid_unit:
    seq:
      - id: unit_id
        type: string_record('UNIT_ID')
      - id: type
        type: string_record('TYPE')
      - id: level
        type: int_record('LEVEL')
      - id: modifier_count
        type: int_record('XXXxxxXXXx') # 10
      - id: modifiers
        type: string_record('MODIF_ID')
        repeat: expr
        repeat-expr: modifier_count.value
      - id: creation
        type: int_record('CREATION')
      - id: name_txt
        type: string_record('NAME_TXT')
      - id: transf
        type: bool_record('TRANSF')
      - id: orig_type_id
        type: string_record('ORIGTYPEID')
        doc: Id of original unit 'GnnnUUnnnn'
        if: transf.value == 1
      - id: keep_hp
        type: bool_record('KEEP_HP')
        if: transf.value == 1
      - id: orig_xp
        type: int_record('ORIG_XP')
        if: transf.value == 1
      - id: hp_before
        type: int_record('HP_BEFORE')
        if: transf.value == 1
      - id: hp_before_max
        type: int_record('HP_BEF_MAX')
        if: transf.value == 1
      - id: dynlevel
        type: bool_record('DYNLEVEL')
        if: (_root.header.signature == 'D2EESFISIG')
          or (_root.header.data.as<midfile_header>.version == 35)
      - id: hp
        type: int_record('HP')
      - id: xp
        type: int_record('XP')
  tile:
    seq:
      - id: type
        type: u1
      - id: unknown
        type: u2
      - id: image_id
        type: u1
  midgard_map_block:
    seq:
      - id: blockid
        type: string_record('BLOCKID')
      - id: blockdata
        type: int_record('BLOCKDATA')
      - id: tiles
        type: tile
        repeat: expr
        repeat-expr: (blockdata.value / 4)
  city:
    seq:
      - id: city_id
        type: string_record('CITY_ID')
      - id: name_txt
        type: string_record('NAME_TXT')
      - id: desc_txt
        type: string_record('DESC_TXT')
      - id: owner
        type: string_record('OWNER')
      - id: subrace
        type: string_record('SUBRACE')
      - id: stack
        type: string_record('STACK')
      - id: position
        type: position
      - id: group
        type: group
  group:
    seq:
      - id: group_id
        type: string_record('GROUP_ID')
      - id: units
        type: string_record('UNIT_N')
        repeat: expr
        repeat-expr: 6
      - id: positions
        type: int_record('POS_N')
        repeat: expr
        repeat-expr: 6
  capital:
    seq:
      - id: city
        type: city
      - id: item_count
        type: int_record('XXXxxxXXXx') # 10
      - id: items
        type: string_record('XXXxxxX') # 7
        repeat: expr
        repeat-expr: (item_count.value)
      - id: aipriority
        type: int_record('AIPRIORITY')
  fog_entry:
    seq:
      - id: pos_y
        type: int_record('POS_Y')
      - id: fog
        type: int_record('FOG')
      - id: fog_mask
        type: b1
        repeat: expr
        repeat-expr: fog.value * 8
        doc: |
          For each Y position we have an entry with a bitmask
          where each bit corresponds to X position,
          thus defining a fog for a tile.
  midgard_map_fog:
    seq:
      - id: count
        type: int_record('XXXxxxXXXx') # 10
      - id: entries
        type: fog_entry
        repeat: expr
        repeat-expr: (count.value)
  diplomacy_entry:
    seq:
      - id: race_1
        type: int_record('RACE_1')
      - id: race_2
        type: int_record('RACE_2')
      - id: relation
        type: int_record('RELATION')
  mid_diplomacy:
    seq:
      - id: count
        type: int_record('XXXxxxXXXx') # 10
      - id: entries
        type: diplomacy_entry
        repeat: expr
        repeat-expr: (count.value)
  plan_entry:
    seq:
      - id: position
        type: position
      - id: element
        type: string_record('ELEMENT')
  midgard_plan:
    seq:
      - id: unknown
        type: int_record('XXXxxxXXXx') # 10
      - id: count
        type: int_record('XXXxxxXXXx') # 10
      - id: entries
        type: plan_entry
        repeat: expr
        repeat-expr: (count.value)
  mid_stack:
    seq:
      - id: group
        type: group
      - id: item_count
        type: int_record('XXXxxxXXXx') # 10
      - id: items
        type: string_record('ITEM_ID')
        repeat: expr
        repeat-expr: item_count.value
      - id: stack_id
        type: string_record('STACK_ID')
      - id: srctmpl_id
        type: string_record('SRCTMPL_ID')
      - id: leader_id
        type: string_record('LEADER_ID')
      - id: leader_aliv
        type: bool_record('LEADR_ALIV')
      - id: position
        type: position
      - id: morale
        type: int_record('MORALE')
      - id: move
        type: int_record('MOVE')
      - id: facing
        type: int_record('FACING')
      - id: banner
        type: string_record('BANNER')
      - id: tome
        type: string_record('TOME')
      - id: battle1
        type: string_record('BATTLE1')
      - id: battle2
        type: string_record('BATTLE2')
      - id: artifact1
        type: string_record('ARTIFACT1')
      - id: artifact2
        type: string_record('ARTIFACT2')
      - id: boots
        type: string_record('BOOTS')
      - id: owner
        type: string_record('OWNER')
      - id: inside
        type: string_record('INSIDE')
      - id: subrace
        type: string_record('SUBRACE')
      - id: invisible
        type: bool_record('INVISIBLE')
      - id: ai_ignore
        type: bool_record('AI_IGNORE')
      - id: upgcount
        type: int_record('UPGCOUNT')
      - id: order
        type: int_record('ORDER')
      - id: order_targ
        type: string_record('ORDER_TARG')
      - id: aiorder
        type: int_record('AIORDER')
      - id: aiordertar
        type: string_record('AIORDERTAR')
      - id: aipriority
        type: int_record('AIPRIORITY')
      - id: creat_lvl
        type: int_record('CREAT_LVL')
      - id: nbbattle
        type: int_record('NBBATTLE')
  unit_modifier:
    seq:
      - id: unit_pos
        type: int_record('UNIT_POS')
      - id: modif_id
        type: string_record('MODIF_ID')
  stack_template_unit_record:
    seq:
      - id: unit
        type: string_record('UNIT_N')
      - id: level
        type: int_record('UNIT_N_LVL')
  mid_stack_template:
    seq:
      - id: id
        type: string_record('ID')
      - id: owner
        type: string_record('OWNER')
      - id: leader
        type: string_record('LEADER')
      - id: leader_lvl
        type: int_record('LEADER_LVL')
      - id: name_txt
        type: string_record('NAME_TXT')
      - id: order_targ
        type: string_record('ORDER_TARG')
      - id: subrace
        type: string_record('SUBRACE')
      - id: order
        type: int_record('ORDER')
      - id: units
        type: stack_template_unit_record
        repeat: expr
        repeat-expr: 6
      - id: positions
        type: int_record('POS_N')
        repeat: expr
        repeat-expr: 6
      - id: use_facing
        type: bool_record('USE_FACING')
      - id: facing
        type: int_record('FACING')
      - id: modifier_count
        type: int_record('XXXxxxXXXx') # 10
      - id: modifiers
        type: unit_modifier
        repeat: expr
        repeat-expr: modifier_count.value
      - id: aipriority
        type: int_record('AIPRIORITY')
        if: _root.header.signature == 'D2EESFISIG'
  mid_item:
    seq:
      - id: item_id
        type: string_record('ITEM_ID')
      - id: item_type
        type: string_record('ITEM_TYPE')
  mid_subrace:
    seq:
      - id: subrace_id
        type: string_record('SUBRACE_ID')
      - id: subrace
        type: int_record('SUBRACE')
      - id: player_id
        type: string_record('PLAYER_ID')
      - id: number
        type: int_record('NUMBER')
      - id: name_txt
        type: string_record('NAME_TXT')
      - id: banner
        type: int_record('BANNER')
  mid_road:
    seq:
      - id: road_id
        type: string_record('ROAD_ID')
      - id: index
        type: int_record('INDEX')
      - id: var
        type: int_record('VAR')
      - id: position
        type: position
  site:
    seq:
      - id: site_id
        type: string_record('SITE_ID')
      - id: img_iso
        type: int_record('IMG_ISO')
      - id: img_intf
        type: string_record('IMG_INTF')
      - id: txt_title
        type: string_record('TXT_TITLE')
      - id: txt_desc
        type: string_record('TXT_DESC')
      - id: position
        type: position
      - id: visiter
        type: string_record('VISITER')
      - id: aipriority
        type: int_record('AIPRIORITY')
  site_visitor:
    seq:
      - id: site_id
        type: string_record('SITE_ID')
      - id: visitor
        type: string_record('VISITER')
  mid_site_mage:
    seq:
      - id: site
        type: site
      - id: spell_count
        type: int_record('QTY_SPELL')
      - id: spells
        type: string_record('SPELL_ID')
        repeat: expr
        repeat-expr: spell_count.value
      - id: visitor_count
        type: int_record('SnnnSInnnn')
      - id: visitors
        type: site_visitor
        repeat: expr
        repeat-expr: visitor_count.value
  mercs_unit_entry:
    seq:
      - id: unit_id
        type: string_record('UNIT_ID')
      - id: unit_level
        type: int_record('UNIT_LEVEL')
      - id: unit_uniq
        type: bool_record('UNIT_UNIQ')
  mid_site_mercs:
    seq:
      - id: site
        type: site
      - id: unit_count
        type: int_record('QTY_UNIT')
      - id: units
        type: mercs_unit_entry
        repeat: expr
        repeat-expr: unit_count.value
      - id: visitor_count
        type: int_record('SnnnSInnnn')
      - id: visitors
        type: site_visitor
        repeat: expr
        repeat-expr: visitor_count.value
  merchant_item_entry:
    seq:
      - id: item_id
        type: string_record('ITEM_ID')
      - id: item_count
        type: int_record('ITEM_COUNT')
  mid_site_merchant:
    seq:
      - id: site
        type: site
      - id: buy_armor
        type: bool_record('BUY_ARMOR')
      - id: buy_jewel
        type: bool_record('BUY_JEWEL')
      - id: buy_weapon
        type: bool_record('BUY_WEAPON')
      - id: buy_banner
        type: bool_record('BUY_BANNER')
      - id: buy_potion
        type: bool_record('BUY_POTION')
      - id: buy_scroll
        type: bool_record('BUY_SCROLL')
      - id: buy_wand
        type: bool_record('BUY_WAND')
      - id: buy_value
        type: bool_record('BUY_VALUE')
      - id: item_count
        type: int_record('QTY_ITEM')
      - id: items
        type: merchant_item_entry
        repeat: expr
        repeat-expr: item_count.value
      - id: mission
        type: bool_record('MISSION')
      - id: visitor_count
        type: int_record('SnnnSInnnn')
      - id: visitors
        type: site_visitor
        repeat: expr
        repeat-expr: visitor_count.value
  ruin_visiter:
    seq:
      - id: ruin_id
        type: string_record('RUIN_ID')
      - id: visiter
        type: string_record('VISITER')
  mid_ruin:
    seq:
      - id: ruin_id
        type: string_record('RUIN_ID')
      - id: title
        type: string_record('TITLE')
      - id: desc
        type: string_record('DESC')
      - id: image
        type: int_record('IMAGE')
      - id: position
        type: position
      - id: cash
        type: bank_record('CASH')
      - id: item
        type: string_record('ITEM')
      - id: looter
        type: string_record('LOOTER')
      - id: aipriority
        type: int_record('AIPRIORITY')
      - id: visitor_count
        type: int_record('XxxxXXxxxx')
      - id: visitors
        type: ruin_visiter
        repeat: expr
        repeat-expr: visitor_count.value
      - id: group
        type: group
  mid_site_trainer:
    seq:
      - id: site
        type: site
      - id: visitor_count
        type: int_record('SnnnSInnnn')
      - id: visitors
        type: site_visitor
        repeat: expr
        repeat-expr: visitor_count.value
  mid_village:
    seq:
      - id: city
        type: city
      - id: item_count
        type: int_record('XXXxxxXXXx')
      - id: items
        type: string_record('ITEM_ID')
        repeat: expr
        repeat-expr: item_count.value
      - id: aipriority
        type: int_record('AIPRIORITY')
      - id: protect_b
        type: string_record('PROTECT_B')
      - id: regen_b
        type: int_record('REGEN_B')
      - id: morale
        type: int_record('MORALE')
      - id: growth_t
        type: int_record('GROWTH_T')
      - id: size
        type: int_record('SIZE')
      - id: p_o_un
        type: bool_record('P_O_UN')
      - id: p_o_he
        type: bool_record('P_O_HE')
      - id: p_o_hu
        type: bool_record('P_O_HU')
      - id: p_o_dw
        type: bool_record('P_O_DW')
      - id: p_o_el
        type: bool_record('P_O_EL')
        if: _root.header.signature == 'D2EESFISIG'
      - id: riot_t
        type: int_record('RIOT_T')
  mid_crystal:
    seq:
      - id: crystal_id
        type: string_record('CRYSTAL_ID')
      - id: reource
        type: int_record('RESOURCE')
      - id: position
        type: position
      - id: aipriority
        type: int_record('AIPRIORITY')
  mid_landmark:
    seq:
      - id: lmark_id
        type: string_record('LMARK_ID')
      - id: type
        type: string_record('TYPE')
      - id: position
        type: position
      - id: desc_txt
        type: string_record('DESC_TXT')
        if: _root.header.signature == 'D2EESFISIG'
  mid_bag:
    seq:
      - id: bag_id
        type: string_record('BAG_ID')
      - id: position
        type: position
      - id: image
        type: int_record('IMAGE')
      - id: aipriority
        type: int_record('AIPRIORITY')
      - id: item_count
        type: int_record('XXXxxxXXXx')
      - id: items
        type: string_record('ITEM_ID')
        repeat: expr
        repeat-expr: (item_count.value)
  mid_location:
    seq:
      - id: loc_id
        type: string_record('LOC_ID')
      - id: position
        type: position
      - id: name_txt
        type: string_record('NAME_TXT')
      - id: radius
        type: int_record('RADIUS')
  event_condition_alliance:
    doc: <id player 1> must be in alliance with <id player 2>
    seq:
      - id: id_player1
        type: string_record('ID_PLAYER1')
      - id: id_player2
        type: string_record('ID_PLAYER2')
  event_condition_destroy_stack:
    doc: <id stack> must be killed by any of the affected races
    seq:
      - id: id_stack
        type: string_record('ID_STACK')
  event_condition_diplomacy_relations:
    doc: <id player 1> must be at <diplomacy> level with <id player 2>
    seq:
      - id: id_player1
        type: string_record('ID_PLAYER1')
      - id: id_player2
        type: string_record('ID_PLAYER2')
      - id: diplomacy
        type: int_record('DIPLOMACY')
  event_condition_entering_a_city:
    doc: there is a stack from the affected races inside the specified city
    seq:
      - id: id_city
        type: string_record('ID_CITY')
  event_condition_entering_a_predefined_zone:
    doc: a stack from the affected races is inside the specified location
    seq:
      - id: id_loc
        type: string_record('ID_LOC')
  event_condition_frequency:
    doc: current turn must be a factor of the specified value
    seq:
      - id: frequency
        type: int_record('FREQUENCY')
  event_condition_item_to_location:
    doc: a stack from the affected races holding an item of the specified type must be inside the specified location
    seq:
      - id: type_item
        type: string_record('TYPE_ITEM')
      - id: id_loc
        type: string_record('ID_LOC')
  event_condition_looting_a_ruin:
    doc: the specified ruin must be looted by any of the affected races
    seq:
      - id: id_ruin
        type: string_record('ID_RUIN')
  event_condition_owning_a_city:
    doc: one of the affected races owns the specified city
    seq:
      - id: id_city
        type: string_record('ID_CITY')
  event_condition_owning_an_item:
    doc: any of the affected races owns an item of the specified type
    seq:
      - id: type_item
        type: string_record('TYPE_ITEM')
  event_condition_specific_leader_owning_an_item:
    doc: specified stack must own specified item (only special items are listed)
    seq:
      - id: type_item
        type: string_record('TYPE_ITEM')
      - id: id_stack
        type: string_record('ID_STACK')
  event_condition_stack_existance:
    doc: specified stack must exist or not
    seq:
      - id: id_stack
        type: string_record('ID_STACK')
      - id: misc_int
        type: int_record('MISC_INT')
        doc: 0 means stack must exist, 1 means stack must NOT exist
  event_condition_stack_to_city:
    doc: specified stack must be in specified city
    seq:
      - id: id_stack
        type: string_record('ID_STACK')
      - id: id_city
        type: string_record('ID_CITY')
  event_condition_stack_to_location:
    doc: specified stack must be on area covered by specified location
    seq:
      - id: id_stack
        type: string_record('ID_STACK')
      - id: id_loc
        type: string_record('ID_LOC')
  event_condition_transforming_land:
    doc: one of the affected races must have transformed the specified percentage of the land
    seq:
      - id: pct_land
        type: int_record('PCT_LAND')
  event_condition_variable_is_in_range:
    doc: the specified variable must be equal or between the min and max value specified
    seq:
      - id: misc_int
        type: int_record('MISC_INT')
      - id: misc_int2
        type: int_record('MISC_INT2')
      - id: misc_int3
        type: int_record('MISC_INT3')
      - id: misc_int4
        type: int_record('MISC_INT4')
      - id: misc_int5
        type: int_record('MISC_INT5')
      - id: misc_int6
        type: int_record('MISC_INT6')
      - id: misc_int7
        type: int_record('MISC_INT7')
  event_condition_visiting_a_site:
    doc: a stack from the affected races must be inside the specified site
    seq:
      - id: id_site
        type: string_record('ID_SITE')
  event_condition:
    seq:
      - id: category
        type: int_record('CATEGORY')
      - id: data
        type:
          switch-on: category.value
          cases:
            9: event_condition_alliance
            5: event_condition_destroy_stack
            8: event_condition_diplomacy_relations
            3: event_condition_entering_a_city
            2: event_condition_entering_a_predefined_zone
            0: event_condition_frequency
            16: event_condition_item_to_location
            10: event_condition_looting_a_ruin
            4: event_condition_owning_a_city
            6: event_condition_owning_an_item
            7: event_condition_specific_leader_owning_an_item
            17: event_condition_stack_existance
            15: event_condition_stack_to_city
            14: event_condition_stack_to_location
            11: event_condition_transforming_land
            18: event_condition_variable_is_in_range
            12: event_condition_visiting_a_site
  event_effect_change_terrain:
    doc: change a block of terrain of size <numvalue> to <lookup> race terrain at location <id_loc>
    seq:
      - id: num
        type: int_record('NUM')
      - id: id_loc
        type: string_record('ID_LOC')
      - id: lookup
        type: int_record('LOOKUP')
      - id: numvalue
        type: int_record('NUMVALUE')
  event_effect_ally_two_ai_players:
    doc: ally the two specified players
    seq:
      - id: num
        type: int_record('NUM')
      - id: id_player1
        type: string_record('ID_PLAYER1')
      - id: id_player2
        type: string_record('ID_PLAYER2')
      - id: permally
        type: bool_record('PERMALLY')
  event_effect_cast_spell_at_specific_location:
    doc: cast the specified spell on the specified location
    seq:
      - id: num
        type: int_record('NUM')
      - id: type_spell
        type: string_record('TYPE_SPELL')
      - id: id_loc
        type: string_record('ID_LOC')
      - id: id_player1
        type: string_record('ID_PLAYER1')
  event_effect_cast_spell_on_triggerer:
    doc: cast the specified spell on the triggerer
    seq:
      - id: num
        type: int_record('NUM')
      - id: type_spell
        type: string_record('TYPE_SPELL')
      - id: id_player1
        doc: id G000000000 means caster is triggerer
        type: string_record('ID_PLAYER1')
  event_effect_change_landmark:
    doc: change the specified landmark to another type
    seq:
      - id: num
        type: int_record('NUM')
      - id: id_lmark
        type: string_record('ID_LMARK')
      - id: type_lmark
        type: string_record('TYPE_LMARK')
  event_effect_change_player_diplomacy_meter:
    doc: change the diplomacy relation between the two specified players
    seq:
      - id: num
        type: int_record('NUM')
      - id: id_player1
        type: string_record('ID_PLAYER1')
      - id: id_player2
        type: string_record('ID_PLAYER2')
      - id: diplomacy
        type: int_record('DIPLOMACY')
      - id: enable
        type: bool_record('ENABLE')
  event_effect_change_scenario_objective_text:
    doc: change the objective of the scenario
    seq:
      - id: num
        type: int_record('NUM')
      - id: object_txt
        type: string_record('OBJECT_TXT')
  event_effect_change_stack_order:
    doc: change the order of the specified stack
    seq:
      - id: num
        type: int_record('NUM')
      - id: id_stack
        type: string_record('ID_STACK')
      - id: order_targ
        type: string_record('ORDER_TARG')
      - id: first_only
        type: bool_record('FIRST_ONLY')
      - id: order
        type: int_record('ORDER')
  event_effect_change_stack_owner:
    doc: change the owner of the specified stack
    seq:
      - id: num
        type: int_record('NUM')
      - id: id_stack
        type: string_record('ID_STACK')
      - id: id_player1
        type: string_record('ID_PLAYER1')
      - id: first_only
        type: bool_record('FIRST_ONLY')
      - id: play_anim
        type: bool_record('PLAY_ANIM')
  event_effect_create_new_stack:
    doc: create a stack from the specified template at the specified location
    seq:
      - id: num
        type: int_record('NUM')
      - id: id_stktemp
        type: string_record('ID_STKTEMP')
      - id: id_loc
        type: string_record('ID_LOC')
  event_effect_destroy_item:
    doc: destroy one or more item of the specified type
    seq:
      - id: num
        type: int_record('NUM')
      - id: type_item
        type: string_record('TYPE_ITEM')
      - id: trig_only
        type: bool_record('TRIG_ONLY')
  event_effect_display_popup_message:
    doc: popup a message
    seq:
      - id: num
        type: int_record('NUM')
      - id: popup_txt
        type: string_record('POPUP_TXT')
      - id: music
        type: string_record('MUSIC')
      - id: sound
        type: string_record('SOUND')
      - id: image
        type: string_record('IMAGE')
      - id: image2
        type: string_record('IMAGE2')
      - id: left_side
        type: bool_record('LEFT_SIDE')
      - id: popup_show
        type: string_record('POPUP_SHOW')
      - id: boolvalue
        type: bool_record('BOOLVALUE')
        if: _root.header.signature == 'D2EESFISIG'
  event_effect_enable_disable_another_event:
    doc: enable/disable another event
    seq:
      - id: num
        type: int_record('NUM')
      - id: id_event
        type: string_record('ID_EVENT')
      - id: enable
        type: bool_record('ENABLE')
  event_effect_give_item:
    doc: give the specified item to triggerer
    seq:
      - id: num
        type: int_record('NUM')
      - id: giveto
        type: int_record('GIVETO')
      - id: type_item
        type: string_record('TYPE_ITEM')
  event_effect_give_spell:
    doc: give the specified spell to the triggerer
    seq:
      - id: num
        type: int_record('NUM')
      - id: type_spell
        type: string_record('TYPE_SPELL')
  event_effect_go_into_battle:
    doc: make the specified stack to go into battle with the triggerer
    seq:
      - id: num
        type: int_record('NUM')
      - id: id_stack
        type: string_record('ID_STACK')
      - id: first_only
        type: bool_record('FIRST_ONLY')
  event_effect_modify_variable:
    doc: modifies the value of a variable
    seq:
      - id: num
        type: int_record('NUM')
      - id: lookup
        type: int_record('LOOKUP')
      - id: numvalue
        type: int_record('NUMVALUE')
      - id: numvalue2
        type: int_record('NUMVALUE2')
  event_effect_move_stack_next_to_triggerer:
    doc: move the specified stack beside the triggerer
    seq:
      - id: num
        type: int_record('NUM')
      - id: id_stack
        type: string_record('ID_STACK')
  event_effect_move_stack_to_specific_location:
    doc: move the specified stack over the specified location
    seq:
      - id: num
        type: int_record('NUM')
      - id: id_stktemp
        type: string_record('ID_STKTEMP')
      - id: id_loc
        type: string_record('ID_LOC')
      - id: boolvalue
        type: bool_record('BOOLVALUE')
        if: _root.header.signature == 'D2EESFISIG'
  event_effect_remove_landmark:
    doc: remove the specified landmark
    seq:
      - id: num
        type: int_record('NUM')
      - id: id_lmark
        type: string_record('ID_LMARK')
      - id: boolvalue
        type: bool_record('BOOLVALUE')
        if: _root.header.signature == 'D2EESFISIG'
  event_effect_remove_mountains_around_a_location:
    doc: remove mountains over the specified location
    seq:
      - id: num
        type: int_record('NUM')
      - id: id_loc
        type: string_record('ID_LOC')
  event_effect_remove_stack:
    doc: remove the specified stack from map
    seq:
      - id: num
        type: int_record('NUM')
      - id: id_stack
        type: string_record('ID_STACK')
      - id: first_only
        type: bool_record('FIRST_ONLY')
  event_effect_unfog_or_fog_an_area_on_the_map_entry:
    seq:
      - id: event_id
        type: string_record('EVENT_ID')
      - id: player
        type: string_record('PLAYER')
  event_effect_unfog_or_fog_an_area_on_the_map:
    doc: unfog or fog an area of the map over the specified location for the specified players
    seq:
      - id: num
        type: int_record('NUM')
      - id: id_loc
        type: string_record('ID_LOC')
      - id: event_count
        type: int_record('XXXxxxXXXx')
      - id: events
        type: event_effect_unfog_or_fog_an_area_on_the_map_entry
        repeat: expr
        repeat-expr: event_count.value
      - id: enable
        type: bool_record('ENABLE')
        if: _root.header.signature == 'D2EESFISIG'
      - id: numvalue
        type: int_record('NUMVALUE')
        if: _root.header.signature == 'D2EESFISIG'
  event_effect_win_or_lose_scenario:
    doc: win or lose the scenario
    seq:
      - id: num
        type: int_record('NUM')
      - id: win_scen
        type: bool_record('WIN_SCEN')
      - id: id_player1
        type: string_record('ID_PLAYER1')
  event_effect:
    seq:
      - id: category
        type: int_record('CATEGORY')
      - id: data
        type:
          switch-on: category.value
          cases:
            22: event_effect_change_terrain
            3: event_effect_cast_spell_at_specific_location
            2: event_effect_cast_spell_on_triggerer
            21: event_effect_change_landmark
            12: event_effect_change_player_diplomacy_meter
            16: event_effect_change_scenario_objective_text
            18: event_effect_change_stack_order
            4: event_effect_change_stack_owner
            1: event_effect_create_new_stack
            19: event_effect_destroy_item
            17: event_effect_display_popup_message
            0: event_effect_win_or_lose_scenario
            13: event_effect_unfog_or_fog_an_area_on_the_map
            20: event_effect_remove_stack
            14: event_effect_remove_mountains_around_a_location
            15: event_effect_remove_landmark
            10: event_effect_move_stack_to_specific_location
            5: event_effect_move_stack_next_to_triggerer
            23: event_effect_modify_variable
            6: event_effect_go_into_battle
            8: event_effect_give_spell
            9: event_effect_give_item
            11: event_effect_ally_two_ai_players
            7: event_effect_enable_disable_another_event
  mid_event:
    seq:
      - id: id
        type: string_record('ID')
      - id: name_txt
        type: string_record('NAME_TXT')
      - id: human
        type: bool_record('HUMAN')
      - id: dwarf
        type: bool_record('DWARF')
      - id: undead
        type: bool_record('UNDEAD')
      - id: heretic
        type: bool_record('HERETIC')
      - id: neutral
        type: bool_record('NEUTRAL')
      - id: elf
        type: bool_record('ELF')
        if: _root.header.signature == 'D2EESFISIG'
      - id: verhuman
        type: bool_record('VERHUMAN')
      - id: verdwarf
        type: bool_record('VERDWARF')
      - id: verundead
        type: bool_record('VERUNDEAD')
      - id: verheretic
        type: bool_record('VERHERETIC')
      - id: verneutral
        type: bool_record('VERNEUTRAL')
      - id: verelf
        type: bool_record('VERELF')
        if: _root.header.signature == 'D2EESFISIG'
      - id: enabled
        type: bool_record('ENABLED')
      - id: occur_once
        type: bool_record('OCCUR_ONCE')
      - id: chance
        type: int_record('CHANCE')
      - id: order
        type: int_record('ORDER')
      - id: cond_qty
        type: int_record('COND_QTY')
        doc: number of event conditions
      - id: conditions
        type: event_condition
        repeat: expr
        repeat-expr: cond_qty.value
      - id: effect_qty
        type: int_record('EFFECT_QTY')
        doc: number of event effects
      - id: effects
        type: event_effect
        repeat: expr
        repeat-expr: effect_qty.value
  talisman_charge:
    seq:
      - id: id_talis
        type: string_record('ID_TALIS')
      - id: charges
        type: int_record('CHARGES')
  mid_talisman_charges:
    seq:
      - id: charges_count
        type: int_record('XXXxxxXXXx')
      - id: charges
        type: talisman_charge
        repeat: expr
        repeat-expr: charges_count.value
  scene_variable:
    seq:
      - id: id
        type: int_record('ID')
      - id: name
        type: string_record('NAME')
      - id: value
        type: int_record('VALUE')
  mid_scen_variables:
    seq:
      - id: variables_count
        type: int_record('XXXxxxXXXx')
      - id: variables
        type: scene_variable
        repeat: expr
        repeat-expr: variables_count.value
  player_known_spells:
    seq:
      - id: spells_count
        type: int_record('XXXxxxXXXx')
      - id: spells
        type: string_record('SPELL_ID')
        repeat: expr
        repeat-expr: spells_count.value
  player_buildings:
    seq:
      - id: buildings_count
        type: int_record('XxxxXXxxxx')
      - id: buildings
        type: string_record('BUILD_ID')
        repeat: expr
        repeat-expr: buildings_count.value
  mid_tomb_entry:
    seq:
      - id: stack_owner
        type: string_record('STACK_OWNR')
      - id: killer
        type: string_record('KILLER')
      - id: turn
        type: int_record('TURN')
      - id: stack_name
        type: string_record('STACK_NAME')
  mid_tomb:
    seq:
      - id: tomb_id
        type: string_record('TOMB_ID')
      - id: position
        type: position
      - id: entry_count
        type: int_record('QTY_EP')
      - id: entries
        type: mid_tomb_entry
        repeat: expr
        repeat-expr: entry_count.value
  turn_summary_entry_type0:
    seq:
      - id: pos_x
        type: int_record('POS_X')
      - id: pos_y
        type: int_record('POS_Y')
      - id: id_player2
        type: string_record('ID_PLAYER2')
      - id: id_spell
        type: string_record('ID_SPELL')
      - id: id_stk_d
        type: string_record('ID_STK_D')
      - id: str_stk_d
        type: string_record('STR_STK_D')
  turn_summary_entry_type1:
    seq:
      - id: position
        type: position
      - id: id_player2
        type: string_record('ID_PLAYER2')
      - id: id_stk_a
        type: string_record('ID_STK_A')
      - id: str_stk_a
        type: string_record('STR_STK_A')
      - id: id_stk_d
        type: string_record('ID_STK_D')
      - id: str_stk_d
        type: string_record('STR_STK_D')
  turn_summary_entry_type2:
    seq:
      - id: position
        type: position
      - id: id_stk_d
        type: string_record('ID_STK_D')
      - id: str_stk_d
        type: string_record('STR_STK_D')
  turn_summary_entry_type3: {}
  turn_summary_entry_type4:
    seq:
      - id: position
        type: position
  turn_summary_entry:
    seq:
      - id: id_player
        type: string_record('ID_PLAYER')
      - id: type
        type: int_record('TYPE')
      - id: data
        type:
          switch-on: type.value
          cases:
            '0': turn_summary_entry_type0
            '1': turn_summary_entry_type1
            '2': turn_summary_entry_type2
            '3': turn_summary_entry_type3
            '4': turn_summary_entry_type4
  turn_summary:
    seq:
      - id: summary_count
        type: int_record('XxxxXXxxxx')
      - id: summary
        type: turn_summary_entry
        repeat: expr
        repeat-expr: summary_count.value
  mid_stack_destroyed_entry:
    seq:
      - id: id_stack
        type: string_record('ID_STACK')
      - id: id_killer
        type: string_record('ID_KILLER')
      - id: srctmpl_id
        type: string_record('SRCTMPL_ID')
  mid_stack_destroyed:
    seq:
      - id: count
        type: int_record('XxxxXXxxxx')
      - id: stacks
        type: mid_stack_destroyed_entry
        repeat: expr
        repeat-expr: count.value
  mid_rod:
    seq:
      - id: rod_id
        type: string_record('ROD_ID')
      - id: owner
        type: string_record('OWNER')
      - id: position
        type: position
  mid_quest_log_sequence:
    seq:
      - id: id_player
        type: string_record('ID_PLAYER')
      - id: seq_num
        type: int_record('SEQ_NUM')
      - id: cur_turn
        type: int_record('CUR_TURN')
      - id: type
        type: int_record('TYPE')
      - id: id_event
        type: string_record('ID_EVENT')
      - id: eff_num
        type: int_record('EFF_NUM')
  mid_quest_log:
    seq:
      - id: log_count
        type: int_record('XxxxXXxxxx')
      - id: sequences
        type: mid_quest_log_sequence
        repeat: expr
        repeat-expr: log_count.value
  scenario_object:
    seq:
      - id: what
        type: string_record('WHAT')
      - id: obj_id
        type: string_record('OBJ_ID')
      - id: begobject
        type: begobject
      - id: data
        type:
          switch-on: what.string
          cases:
            '".?AVCMidStackDestroyed@@"': mid_stack_destroyed
            '".?AVCScenarioInfo@@"': scenario_info
            '".?AVCMidMountains@@"': mid_mountains
            '".?AVCMidPlayer@@"': mid_player
            '".?AVCMidQuestLog@@"': mid_quest_log
            '".?AVCPlayerBuildings@@"': player_buildings
            '".?AVCMidSpellCast@@"': mid_spell_cast
            '".?AVCMidUnit@@"': mid_unit
            '".?AVCMidgardMapBlock@@"': midgard_map_block
            '".?AVCCapital@@"': capital
            '".?AVCMidgardMapFog@@"': midgard_map_fog
            '".?AVCMidDiplomacy@@"': mid_diplomacy
            '".?AVCMidgardPlan@@"': midgard_plan
            '".?AVCMidScenVariables@@"': mid_scen_variables
            '".?AVCMidStack@@"': mid_stack
            '".?AVCMidStackTemplate@@"': mid_stack_template
            '".?AVCMidgardMap@@"': single_id
            '".?AVCMidItem@@"': mid_item
            '".?AVCMidTalismanCharges@@"': mid_talisman_charges
            '".?AVCMidSpellEffects@@"': mid_spell_effects
            '".?AVCMidSubRace@@"': mid_subrace
            '".?AVCPlayerKnownSpells@@"': player_known_spells
            '".?AVCTurnSummary@@"': turn_summary
            '".?AVCMidRoad@@"': mid_road
            '".?AVCMidSiteMage@@"': mid_site_mage
            '".?AVCMidSiteMercs@@"': mid_site_mercs
            '".?AVCMidSiteMerchant@@"': mid_site_merchant
            '".?AVCMidRuin@@"': mid_ruin
            '".?AVCMidSiteTrainer@@"': mid_site_trainer
            '".?AVCMidVillage@@"': mid_village
            '".?AVCMidCrystal@@"': mid_crystal
            '".?AVCMidLandmark@@"': mid_landmark
            '".?AVCMidBag@@"': mid_bag
            '".?AVCMidLocation@@"': mid_location
            '".?AVCMidEvent@@"': mid_event
            '".?AVCMidTomb@@"': mid_tomb
            '".?AVCMidRod@@"': mid_rod
      - id: endobject
        type: endobject
