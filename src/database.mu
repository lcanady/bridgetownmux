&list.bio [v(d.cdo)]=
	full name|
    concept|
    birthdate|
    template|
    ambition|
    desire|
    clan|
    sire|
    predator|
    generation

&values.clan [v(d.cdo)]=
    brujah|
    gangrel|
    malkavian|
    nosferatu|
    toreador|
    tremere|
    venture|
    caitiff|
    thin-blood

&pre.clan [v(d.cdo)]= template:vampire
&error.clan [v(d.cdo)]= Template required: Vampire.

&pre.sire [v(d.cdo)]= template:vampire
&error.sire [v(d.cdo)]= Template required: Vampire.


&values.predator [v(d.cdo)]=
    alleycat|
    bagger|
    blood leech|
    cleaver|
    consensualist|
    farmer|
    osiris|
    sandman|
    scene queen|
    siren

&pre.predator [v(d.cdo)]= template:vampire
&error.predator [v(d.cdo)]= Template required: Vampire.

&values.generation [v(d.cdo)]= 1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16
&pre.generation [v(d.cdo)]= template:vampire
&error.generation [v(d.cdo)]= Template required: Vampire.
  

&list.stats [v(d.cdo)]=
	strength|
    dexterity|
    stamina|
    charisma|
    manipulation|
    composure|
    intelligence|
    wits|
    resolve


&values.stats [v(d.cdo)] = 1|2|3|4|5|6
&values.skills [v(d.cdo)] = 0|1|2|3|4|5|6|7|8|9|10

&trigger.stats [v(d.cdo)] = 
&_stats.health.perm %0= 
add(
    get(%0/_stats.composure.perm), 
    get(%0/_stats.resolve.perm)
);
&_stats.health.temp %0= 
    add(
        get(%0/_stats.composure.perm), 
        get(%0/_stats.resolve.perm)
    );
  
&_stats.willpower.perm %0= add(3, get(%0/_stats.resolve.perm));
&_stats.willpower.temp %0= add(3, get(%0/_stats.resolve.perm));


&list.skills [v(d.cdo)]=
	athletics|
    brawl|
    craft|
    drive|
    firearms|
    larceny|
    melee|
    stealth|
    survival|
    animal ken|
    etiquette|
    insight|
    intimidation|
    leadership|
    performance|
    persuasion|
    streetwise|
    subterfuge|
    academics|
    awareness|
    finance|
    investigation|
    medicine|
    occult|
    politics|
    science|
    medicine|
    occult|
    technology

&list.flaws [v(d.cdo)] =
	illiterate|
    repulsive|
    ugly|
    helpless addiction|
    addiction|
    archaic|
    living in the past
    bondslave|
    bond Junkie|
    long bond|
    farmer|
    organovore|
    metheuselah's thirst|
    prey exclusion|
    stake bait|
    folklore bane|
    folklore block|
    stigmata|
    baby teeth|
    beastial temper|
    branded by the camarilla|
    clan curse|
    dead flesh|
    mortal frailty|
    shunned by anarchs|
    vitae dependancy|
    infamy|
    dark secret|
    despised|
    disliked|
    no haven|
    obvious predator|
    known blankbody|
    known corpse|
    adversary|
    destitute|
    stalkers|
    shunned|
    suspect|
  
&list.merits [v(d.cdo)] = 
	beautiful|
    stunning|
    bond resistance|
    short bond|
    unbondable|
    bloodhound|
    iron gullet|
    eat food|
    anarch comrades|
    camarilla contact|
    catenating blood|
    day drinker|
    discipline affinity|
    lifelike|
    thin-blood alchemist|
    vampiric resistance|
    allies|
    contacts|
	fame|
    influence|
    haven|
    herd|
    zeroed|
    cobbler|
    mawla|
    resources|
    status
  
&list.pools [v(d.cdo)]=
	health|
    willpower|
    hunger|
    humanity

&list.disciplines [v(d.cdo)] = 
	animalism|
    auspex|
    celerity|
    dominate|
    fortitude|
    obfuscate|
    potence|
    presence|
    protean|
    blood sorcery|
    rituals|
    thin-blood alchemy

&list.animalism [v(d.cdo)] =
	bond famulus|
    sense beast|
    feral whispers|
    animal succulence|
    quell the beast|
    unliving hive|
    subsume the spirit|
    animal dominion|
    drawing out the beast
  


&list.auspex [v(d.cdo)] = 
	heightened senses|
    sense the unseen|
    premonition|
    scry the soul|
    share the senses|
    spirit's touch|
    clairvoyance|
    posession|
    telepathy


&list.celerity [v(d.cdo)] =
    cat's grace|
    rapid reflexes|
    fleetness|
    blink|
    traversal|
    draught of elegance|
    unerring aim|
    lightning strike|
    split second


&list.dominate [v(d.cdo)] =
    cloud memory|
    compel|
    mesmerize|
    dementation|
    the forgetuful mind|
    submerged directive|
    rationalize|
    mass manipulation|
    terminal decree


&list.fortitude [v(d.cdo)] =
    resilience|
    unsayable mind|
    toughness|
    enduring beasts|
    defy bane|
    fortify the inner facade|
    draught of endurance|
    flesh of marble|
    prowesss from pain

&list.obfuscate [v(d.cdo)] =
    cloak of shadows|
    silence of death|
    unseen passage|
    ghost in the machine|
    mask if a thousand faces|
    concel|
    vanish|
    cloak of the gathering|
    imposter's curse

&list.potence [v(d.cdo)] =
    lethal body|
    soaring leap|
    prowess|
    brutal feed|
    spark of rage|
    uncanny grip|
    draught of might|
    earthshock|
    fist of cane 

&list.presence [v(d.cdo)] =
    awe|
    daunt|
    lingering kiss|
    dread gaze|
    entrancement|
    irresistible voice|
    summon|
    majesty|
    star magnetism

&list.protean [v(d.cdo)] =
    eyes of the beast|
    weight of the feather|
    feral weapons|
    earth meld|
    shapechange|
    metempophosis|
    mist form|
    the unfettered beast|

&list.blood_sorcery [v(d.cdo)] =
    corrosive vitae|
    a taste for blood|
    extinguish vitae|
    blood of potency|
    scorpion's touch|
    theft of vitae|
    baal's caress|
    cauldron of blood

&list.rituals [v(d.cdo)] = 
    blood walk|
    cling of the insect|
    craft bloodstone|
    walk with evening's freshness|
    ward against ghouls|
    eyes of babel|
    illuminate the trail of prey|
    truth of blood|
    ward against spirits|
    warding circle against ghouls|
    dragon's call|
    defelction of wooden doom|
    esscence of air|
    firewalker|
    ward against lupines|
    warding circle against spirits|
    defense of the sacred haven|
    eyes of the nighthawk|
    incorporeal passage|
    ward against canites|
    warding circle against lupines|
    escape to true sanctuary|
    heart of stone|
    shaft of belated dissolution|
    warding circle against canites|

&list.thin-blood_alchemy [v(d.cdo)]=
    far reach|
    envelop|
    defractionate|
    profane heroes gamos|
    airborne momentum|
    awaken the sleeper



  &skills.physical [v(d.cco)] = 
	athletics|
    brawl|
    craft|
    drive|
    firearms|
    larceny|
    melee|
    stealth|
    survival
  
&skills.social [v(d.cco)]=
	animal ken|
    etiquette|
    insight|
    intimidation|
    leadership|
    performance|
    persuasion|
    streetwise|
    subterfuge
  
&skills.mental [v(d.cco)]= 
	academics|
    awareness|
    finance|
    investigation|
    medicine|
    occult|
    politics|
    science|
    technology

  &sheet.bio [v(d.cdo)] =
      