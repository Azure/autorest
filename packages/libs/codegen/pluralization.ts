import { pascalCase, deconstruct } from "./text-manipulation";

/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

/*
 * PORTED FROM System.Data.Entity.Infrastructure.Pluralization.EnglishPluralizationService (EntityFramework.dll)
 */

class StringBidirectionalDictionary {
  private dictForward: Map<string, string> = new Map<string, string>();
  private dictBackward: Map<string, string> = new Map<string, string>();

  constructor(dict: { [key: string]: string } = {}) {
    for (const key of Object.keys(dict)) {
      const value = dict[key];
      this.addValue(key, value);
    }
  }

  public addValue(first: string, second: string): void {
    this.dictForward.set(first, second);
    this.dictBackward.set(second, first);
  }

  public existsInFirst(s: string): boolean {
    return this.dictForward.has(s);
  }

  public existsInSecond(s: string): boolean {
    return this.dictBackward.has(s);
  }

  public getFirstValue(s: string): string {
    return (
      this.dictBackward.get(s) ||
      (() => {
        throw new Error("Cannot find key.");
      })()
    );
  }

  public getSecondValue(s: string): string {
    return (
      this.dictForward.get(s) ||
      (() => {
        throw new Error("Cannot find key.");
      })()
    );
  }
}

function endsWithIgnoreCase(word: string, suffix: string): boolean {
  return word.toLowerCase().endsWith(suffix.toLowerCase());
}

class PluralizationServiceUtil {
  static DoesWordContainSuffix(word: string, suffixes: Array<string>): boolean {
    return suffixes.some((s) => endsWithIgnoreCase(word, s));
  }

  static TryInflectOnSuffixInWord(
    word: string,
    suffixes: Array<string>,
    operationOnWord: (word: string) => string,
  ): string | null {
    if (PluralizationServiceUtil.DoesWordContainSuffix(word, suffixes)) {
      return operationOnWord(word);
    } else {
      return null;
    }
  }
}

export class EnglishPluralizationService {
  private userDictionary: StringBidirectionalDictionary;
  private irregularPluralsPluralizationService: StringBidirectionalDictionary;
  private assimilatedClassicalInflectionPluralizationService: StringBidirectionalDictionary;
  private oSuffixPluralizationService: StringBidirectionalDictionary;
  private classicalInflectionPluralizationService: StringBidirectionalDictionary;
  private irregularVerbPluralizationService: StringBidirectionalDictionary;
  private wordsEndingWithSePluralizationService: StringBidirectionalDictionary;
  private wordsEndingWithSisPluralizationService: StringBidirectionalDictionary;
  private wordsEndingWithSusPluralizationService: StringBidirectionalDictionary;
  private wordsEndingWithInxAnxYnxPluralizationService: StringBidirectionalDictionary;

  private knownSingluarWords: Array<string>;
  private knownPluralWords: Array<string>;

  private uninflectiveSuffixList: Array<string> = ["fish", "ois", "sheep", "deer", "pos", "itis", "ism"];

  private uninflectiveWordList: Array<string> = [
    "bison",
    "flounder",
    "pliers",
    "bream",
    "gallows",
    "proceedings",
    "breeches",
    "graffiti",
    "rabies",
    "britches",
    "headquarters",
    "salmon",
    "carp",
    "----",
    "scissors",
    "ch----is",
    "high-jinks",
    "sea-bass",
    "clippers",
    "homework",
    "series",
    "cod",
    "innings",
    "shears",
    "contretemps",
    "jackanapes",
    "species",
    "corps",
    "mackerel",
    "swine",
    "debris",
    "measles",
    "trout",
    "diabetes",
    "mews",
    "tuna",
    "djinn",
    "mumps",
    "whiting",
    "eland",
    "news",
    "wildebeest",
    "elk",
    "pincers",
    "police",
    "hair",
    "ice",
    "chaos",
    "milk",
    "cotton",
    "pneumonoultramicroscopicsilicovolcanoconiosis",
    "information",
    "aircraft",
    "scabies",
    "traffic",
    "corn",
    "millet",
    "rice",
    "hay",
    "----",
    "tobacco",
    "cabbage",
    "okra",
    "broccoli",
    "asparagus",
    "lettuce",
    "beef",
    "pork",
    "venison",
    "mutton",
    "cattle",
    "offspring",
    "molasses",
    "shambles",
    "shingles",
    "https",
    "sas",
    "statuses",
    "as",
    "statistics",
    "alias",
    "dns",
    "ms",
    "os",
    "vmss",
    "acls",
    "rights",
    "credentials",
    "ddos",
    "media",
    "gbps",
    "kbps",
    "mbps",
    "bps",
    "fips",
  ];

  private irregularVerbList: { [key: string]: string } = {
    am: "are",
    are: "are",
    is: "are",
    was: "were",
    were: "were",
    has: "have",
    have: "have",
  };

  private pronounList: Array<string> = [
    "I",
    "we",
    "you",
    "he",
    "she",
    "they",
    "it",
    "me",
    "us",
    "him",
    "her",
    "them",
    "myself",
    "ourselves",
    "yourself",
    "himself",
    "herself",
    "itself",
    "oneself",
    "oneselves",
    "my",
    "our",
    "your",
    "his",
    "their",
    "its",
    "mine",
    "yours",
    "hers",
    "theirs",
    "this",
    "that",
    "these",
    "those",
    "all",
    "another",
    "any",
    "anybody",
    "anyone",
    "anything",
    "both",
    "each",
    "other",
    "either",
    "everyone",
    "everybody",
    "everything",
    "most",
    "much",
    "nothing",
    "nobody",
    "none",
    "one",
    "others",
    "some",
    "somebody",
    "someone",
    "something",
    "what",
    "whatever",
    "which",
    "whichever",
    "who",
    "whoever",
    "whom",
    "whomever",
    "whose",
  ];

  private irregularPluralsDictionary: { [key: string]: string } = {
    brother: "brothers",
    child: "children",
    cow: "cows",
    ephemeris: "ephemerides",
    genie: "genies",
    money: "moneys",
    mongoose: "mongooses",
    mythos: "mythoi",
    octopus: "octopuses",
    ox: "oxen",
    soliloquy: "soliloquies",
    trilby: "trilbys",
    crisis: "crises",
    synopsis: "synopses",
    rose: "roses",
    gas: "gases",
    bus: "buses",
    axis: "axes",
    memo: "memos",
    casino: "casinos",
    silo: "silos",
    stereo: "stereos",
    studio: "studios",
    lens: "lenses",
    alias: "aliases",
    pie: "pies",
    corpus: "corpora",
    viscus: "viscera",
    hippopotamus: "hippopotami",
    trace: "traces",
    person: "people",
    chili: "chilies",
    analysis: "analyses",
    basis: "bases",
    neurosis: "neuroses",
    oasis: "oases",
    synthesis: "syntheses",
    thesis: "theses",
    change: "changes",
    lie: "lies",
    calorie: "calories",
    freebie: "freebies",
    case: "cases",
    house: "houses",
    valve: "valves",
    cloth: "clothes",
    tie: "ties",
    movie: "movies",
    bonus: "bonuses",
    specimen: "specimens",
  };

  private assimilatedClassicalInflectionDictionary: { [key: string]: string } = {
    alumna: "alumnae",
    alga: "algae",
    vertebra: "vertebrae",
    codex: "codices",
    murex: "murices",
    silex: "silices",
    aphelion: "aphelia",
    hyperbaton: "hyperbata",
    perihelion: "perihelia",
    asyndeton: "asyndeta",
    noumenon: "noumena",
    phenomenon: "phenomena",
    criterion: "criteria",
    organon: "organa",
    prolegomenon: "prolegomena",
    agendum: "agenda",
    extremum: "extrema",
    bacterium: "bacteria",
    desideratum: "desiderata",
    stratum: "strata",
    candelabrum: "candelabra",
    erratum: "errata",
    ovum: "ova",
    forum: "fora",
    addendum: "addenda",
    stadium: "stadia",
    automaton: "automata",
    polyhedron: "polyhedra",
  };

  private oSuffixDictionary: { [key: string]: string } = {
    albino: "albinos",
    generalissimo: "generalissimos",
    manifesto: "manifestos",
    archipelago: "archipelagos",
    ghetto: "ghettos",
    medico: "medicos",
    armadillo: "armadillos",
    guano: "guanos",
    octavo: "octavos",
    commando: "commandos",
    inferno: "infernos",
    photo: "photos",
    ditto: "dittos",
    jumbo: "jumbos",
    pro: "pros",
    dynamo: "dynamos",
    lingo: "lingos",
    quarto: "quartos",
    embryo: "embryos",
    lumbago: "lumbagos",
    rhino: "rhinos",
    fiasco: "fiascos",
    magneto: "magnetos",
    stylo: "stylos",
  };

  private classicalInflectionDictionary: { [key: string]: string } = {
    "stamen": "stamina",
    "foramen": "foramina",
    "lumen": "lumina",
    "anathema": "anathemata",
    "----": "----ta",
    "oedema": "oedemata",
    "bema": "bemata",
    "enigma": "enigmata",
    "sarcoma": "sarcomata",
    "carcinoma": "carcinomata",
    "gumma": "gummata",
    "schema": "schemata",
    "charisma": "charismata",
    "lemma": "lemmata",
    "soma": "somata",
    "diploma": "diplomata",
    "lymphoma": "lymphomata",
    "stigma": "stigmata",
    "dogma": "dogmata",
    "magma": "magmata",
    "stoma": "stomata",
    "drama": "dramata",
    "melisma": "melismata",
    "trauma": "traumata",
    "edema": "edemata",
    "miasma": "miasmata",
    "abscissa": "abscissae",
    "formula": "formulae",
    "medusa": "medusae",
    "amoeba": "amoebae",
    "hydra": "hydrae",
    "nebula": "nebulae",
    "antenna": "antennae",
    "hyperbola": "hyperbolae",
    "nova": "novae",
    "aurora": "aurorae",
    "lacuna": "lacunae",
    "parabola": "parabolae",
    "apex": "apices",
    "latex": "latices",
    "vertex": "vertices",
    "cortex": "cortices",
    "pontifex": "pontifices",
    "vortex": "vortices",
    "index": "indices",
    "simplex": "simplices",
    "iris": "irides",
    "----oris": "----orides",
    "alto": "alti",
    "contralto": "contralti",
    "soprano": "soprani",
    "b----o": "b----i",
    "crescendo": "crescendi",
    "tempo": "tempi",
    "canto": "canti",
    "solo": "soli",
    "aquarium": "aquaria",
    "interregnum": "interregna",
    "quantum": "quanta",
    "compendium": "compendia",
    "lustrum": "lustra",
    "rostrum": "rostra",
    "consortium": "consortia",
    "maximum": "maxima",
    "spectrum": "spectra",
    "cranium": "crania",
    "medium": "media",
    "speculum": "specula",
    "curriculum": "curricula",
    "memorandum": "memoranda",
    "stadium": "stadia",
    "dictum": "dicta",
    "millenium": "millenia",
    "t----zium": "t----zia",
    "emporium": "emporia",
    "minimum": "minima",
    "ultimatum": "ultimata",
    "enconium": "enconia",
    "momentum": "momenta",
    "vacuum": "vacua",
    "gymnasium": "gymnasia",
    "optimum": "optima",
    "velum": "vela",
    "honorarium": "honoraria",
    "phylum": "phyla",
    "focus": "foci",
    "nimbus": "nimbi",
    "succubus": "succubi",
    "fungus": "fungi",
    "nucleolus": "nucleoli",
    "torus": "tori",
    "genius": "genii",
    "radius": "radii",
    "umbilicus": "umbilici",
    "incubus": "incubi",
    "stylus": "styli",
    "uterus": "uteri",
    "stimulus": "stimuli",
    "apparatus": "apparatus",
    "impetus": "impetus",
    "prospectus": "prospectus",
    "cantus": "cantus",
    "nexus": "nexus",
    "sinus": "sinus",
    "coitus": "coitus",
    "plexus": "plexus",
    "status": "status",
    "hiatus": "hiatus",
    "afreet": "afreeti",
    "afrit": "afriti",
    "efreet": "efreeti",
    "cherub": "cherubim",
    "goy": "goyim",
    "seraph": "seraphim",
    "alumnus": "alumni",
  };

  // this list contains all the plural words that being treated as singluar form, for example, "they" -> "they"
  private knownConflictingPluralList: Array<string> = ["they", "them", "their", "have", "were", "yourself", "are"];

  // this list contains the words ending with "se" and we special case these words since
  // we need to add a rule for "ses" singularize to "s"
  private wordsEndingWithSeDictionary: { [key: string]: string } = {
    "house": "houses",
    "case": "cases",
    "enterprise": "enterprises",
    "purchase": "purchases",
    "surprise": "surprises",
    "release": "releases",
    "disease": "diseases",
    "promise": "promises",
    "refuse": "refuses",
    "whose": "whoses",
    "phase": "phases",
    "noise": "noises",
    "nurse": "nurses",
    "rose": "roses",
    "franchise": "franchises",
    "supervise": "supervises",
    "farmhouse": "farmhouses",
    "suitcase": "suitcases",
    "recourse": "recourses",
    "impulse": "impulses",
    "license": "licenses",
    "diocese": "dioceses",
    "excise": "excises",
    "demise": "demises",
    "blouse": "blouses",
    "bruise": "bruises",
    "misuse": "misuses",
    "curse": "curses",
    "prose": "proses",
    "purse": "purses",
    "goose": "gooses",
    "tease": "teases",
    "poise": "poises",
    "vase": "vases",
    "fuse": "fuses",
    "muse": "muses",
    "slaughterhouse": "slaughterhouses",
    "clearinghouse": "clearinghouses",
    "endonuclease": "endonucleases",
    "steeplechase": "steeplechases",
    "metamorphose": "metamorphoses",
    "----": "----s",
    "commonsense": "commonsenses",
    "intersperse": "intersperses",
    "merchandise": "merchandises",
    "phosphatase": "phosphatases",
    "summerhouse": "summerhouses",
    "watercourse": "watercourses",
    "catchphrase": "catchphrases",
    "compromise": "compromises",
    "greenhouse": "greenhouses",
    "lighthouse": "lighthouses",
    "paraphrase": "paraphrases",
    "mayonnaise": "mayonnaises",
    "----course": "----courses",
    "apocalypse": "apocalypses",
    "courthouse": "courthouses",
    "powerhouse": "powerhouses",
    "storehouse": "storehouses",
    "glasshouse": "glasshouses",
    "hypotenuse": "hypotenuses",
    "peroxidase": "peroxidases",
    "pillowcase": "pillowcases",
    "roundhouse": "roundhouses",
    "streetwise": "streetwises",
    "expertise": "expertises",
    "discourse": "discourses",
    "warehouse": "warehouses",
    "staircase": "staircases",
    "workhouse": "workhouses",
    "briefcase": "briefcases",
    "clubhouse": "clubhouses",
    "clockwise": "clockwises",
    "concourse": "concourses",
    "playhouse": "playhouses",
    "turquoise": "turquoises",
    "boathouse": "boathouses",
    "cellulose": "celluloses",
    "epitomise": "epitomises",
    "gatehouse": "gatehouses",
    "grandiose": "grandioses",
    "menopause": "menopauses",
    "penthouse": "penthouses",
    "----horse": "----horses",
    "transpose": "transposes",
    "almshouse": "almshouses",
    "customise": "customises",
    "footloose": "footlooses",
    "galvanise": "galvanises",
    "princesse": "princesses",
    "universe": "universes",
    "workhorse": "workhorses",
    "response": "responses",
    "phrase": "phrases",
  };

  private wordsEndingWithSisDictionary: { [key: string]: string } = {
    analysis: "analyses",
    crisis: "crises",
    basis: "bases",
    atherosclerosis: "atheroscleroses",
    electrophoresis: "electrophoreses",
    psychoanalysis: "psychoanalyses",
    photosynthesis: "photosyntheses",
    amniocentesis: "amniocenteses",
    metamorphosis: "metamorphoses",
    toxoplasmosis: "toxoplasmoses",
    endometriosis: "endometrioses",
    tuberculosis: "tuberculoses",
    pathogenesis: "pathogeneses",
    osteoporosis: "osteoporoses",
    parenthesis: "parentheses",
    anastomosis: "anastomoses",
    peristalsis: "peristalses",
    hypothesis: "hypotheses",
    antithesis: "antitheses",
    apotheosis: "apotheoses",
    thrombosis: "thromboses",
    diagnosis: "diagnoses",
    synthesis: "syntheses",
    paralysis: "paralyses",
    prognosis: "prognoses",
    cirrhosis: "cirrhoses",
    sclerosis: "scleroses",
    psychosis: "psychoses",
    apoptosis: "apoptoses",
    symbiosis: "symbioses",
    redis: "redis",
  };

  private wordsEndingWithSusDictionary: { [key: string]: string } = {
    consensus: "consensuses",
    census: "censuses",
    status: "statuses",
  };

  private wordsEndingWithInxAnxYnxDictionary: { [key: string]: string } = {
    sphinx: "sphinxes",
    larynx: "larynges",
    lynx: "lynxes",
    pharynx: "pharynxes",
    phalanx: "phalanxes",
  };

  constructor() {
    // eslint-disable-next-line prefer-spread
    const flatten = <T>(l: Array<Array<T>>): Array<T> => (<Array<T>>[]).concat.apply(<Array<T>>[], l);

    this.userDictionary = new StringBidirectionalDictionary();

    this.irregularPluralsPluralizationService = new StringBidirectionalDictionary(this.irregularPluralsDictionary);
    this.assimilatedClassicalInflectionPluralizationService = new StringBidirectionalDictionary(
      this.assimilatedClassicalInflectionDictionary,
    );
    this.oSuffixPluralizationService = new StringBidirectionalDictionary(this.oSuffixDictionary);
    this.classicalInflectionPluralizationService = new StringBidirectionalDictionary(
      this.classicalInflectionDictionary,
    );
    this.wordsEndingWithSePluralizationService = new StringBidirectionalDictionary(this.wordsEndingWithSeDictionary);
    this.wordsEndingWithSisPluralizationService = new StringBidirectionalDictionary(this.wordsEndingWithSisDictionary);
    this.wordsEndingWithSusPluralizationService = new StringBidirectionalDictionary(this.wordsEndingWithSusDictionary);
    this.wordsEndingWithInxAnxYnxPluralizationService = new StringBidirectionalDictionary(
      this.wordsEndingWithInxAnxYnxDictionary,
    );

    // verb
    this.irregularVerbPluralizationService = new StringBidirectionalDictionary(this.irregularVerbList);

    this.knownSingluarWords = flatten([
      Object.keys(this.irregularPluralsDictionary),
      Object.keys(this.assimilatedClassicalInflectionDictionary),
      Object.keys(this.oSuffixDictionary),
      Object.keys(this.classicalInflectionDictionary),
      Object.keys(this.irregularVerbList),
      Object.keys(this.irregularPluralsDictionary),
      Object.keys(this.wordsEndingWithSeDictionary),
      Object.keys(this.wordsEndingWithSisDictionary),
      Object.keys(this.wordsEndingWithSusDictionary),
      Object.keys(this.wordsEndingWithInxAnxYnxDictionary),
      Object.keys(this.uninflectiveWordList),
    ]).filter((x) => !this.knownConflictingPluralList.includes(x)); // see the _knowConflictingPluralList comment above

    this.knownPluralWords = flatten([
      Object.values(this.irregularPluralsDictionary),
      Object.values(this.assimilatedClassicalInflectionDictionary),
      Object.values(this.oSuffixDictionary),
      Object.values(this.classicalInflectionDictionary),
      Object.values(this.irregularVerbList),
      Object.values(this.irregularPluralsDictionary),
      Object.values(this.wordsEndingWithSeDictionary),
      Object.values(this.wordsEndingWithSisDictionary),
      Object.values(this.wordsEndingWithSusDictionary),
      Object.values(this.wordsEndingWithInxAnxYnxDictionary),
      Object.values(this.uninflectiveWordList),
    ]);
  }

  public isPlural(word: string): boolean {
    if (this.userDictionary.existsInSecond(word)) {
      return true;
    }
    if (this.userDictionary.existsInFirst(word)) {
      return false;
    }

    if (this.isUninflective(word) || this.knownPluralWords.includes(word.toLowerCase())) {
      return true;
    } else if (this.singularize(word) === word) {
      return false;
    } else {
      return true;
    }
  }

  public isSingular(word: string): boolean {
    if (this.userDictionary.existsInFirst(word)) {
      return true;
    }
    if (this.userDictionary.existsInSecond(word)) {
      return false;
    }

    if (this.isUninflective(word) || this.knownSingluarWords.includes(word.toLowerCase())) {
      return true;
    } else if (!this.isNoOpWord(word) && this.singularize(word) === word) {
      return true;
    } else {
      return false;
    }
  }

  //
  public pluralize(word: string): string {
    return this.capitalize(word, (w) => this.internalPluralize(w));
  }

  private internalPluralize(word: string): string {
    // words that we know of
    if (this.userDictionary.existsInFirst(word)) {
      return this.userDictionary.getSecondValue(word);
    }

    if (this.isNoOpWord(word)) {
      return word;
    }

    const { prefixWord, suffixWord } = this.getSuffixWord(word);

    // by me -> by me
    if (this.isNoOpWord(suffixWord)) {
      return prefixWord + suffixWord;
    }

    // handle the word that do not inflect in the plural form
    if (this.isUninflective(suffixWord)) {
      return prefixWord + suffixWord;
    }

    // if word is one of the known plural forms, then just return
    if (this.knownPluralWords.includes(suffixWord.toLowerCase()) || this.isPlural(suffixWord)) {
      return prefixWord + suffixWord;
    }

    // handle irregular plurals, e.g. "ox" -> "oxen"
    if (this.irregularPluralsPluralizationService.existsInFirst(suffixWord)) {
      return prefixWord + this.irregularPluralsPluralizationService.getSecondValue(suffixWord);
    }

    let newSuffixWord: string | null;
    newSuffixWord = PluralizationServiceUtil.TryInflectOnSuffixInWord(
      suffixWord,
      ["man"],
      (s) => `${s.slice(0, -2)}en`,
    );
    if (newSuffixWord !== null) {
      return prefixWord + newSuffixWord;
    }

    // handle irregular inflections for common suffixes, e.g. "mouse" -> "mice"
    newSuffixWord = PluralizationServiceUtil.TryInflectOnSuffixInWord(
      suffixWord,
      ["louse", "mouse"],
      (s) => `${s.slice(0, -4)}ice`,
    );
    if (newSuffixWord !== null) {
      return prefixWord + newSuffixWord;
    }

    newSuffixWord = PluralizationServiceUtil.TryInflectOnSuffixInWord(
      suffixWord,
      ["tooth"],
      (s) => `${s.slice(0, -4)}eeth`,
    );
    if (newSuffixWord !== null) {
      return prefixWord + newSuffixWord;
    }

    newSuffixWord = PluralizationServiceUtil.TryInflectOnSuffixInWord(
      suffixWord,
      ["goose"],
      (s) => `${s.slice(0, -4)}eese`,
    );
    if (newSuffixWord !== null) {
      return prefixWord + newSuffixWord;
    }

    newSuffixWord = PluralizationServiceUtil.TryInflectOnSuffixInWord(
      suffixWord,
      ["foot"],
      (s) => `${s.slice(0, -3)}eet`,
    );
    if (newSuffixWord !== null) {
      return prefixWord + newSuffixWord;
    }

    newSuffixWord = PluralizationServiceUtil.TryInflectOnSuffixInWord(
      suffixWord,
      ["zoon"],
      (s) => `${s.slice(0, -3)}oa`,
    );
    if (newSuffixWord !== null) {
      return prefixWord + newSuffixWord;
    }

    newSuffixWord = PluralizationServiceUtil.TryInflectOnSuffixInWord(
      suffixWord,
      ["cis", "sis", "xis"],
      (s) => `${s.slice(0, -2)}es`,
    );
    if (newSuffixWord !== null) {
      return prefixWord + newSuffixWord;
    }

    // handle assimilated classical inflections, e.g. vertebra -> vertebrae
    if (this.assimilatedClassicalInflectionPluralizationService.existsInFirst(suffixWord)) {
      return prefixWord + this.assimilatedClassicalInflectionPluralizationService.getSecondValue(suffixWord);
    }

    // Handle the classical variants of modern inflections
    //
    if (this.classicalInflectionPluralizationService.existsInFirst(suffixWord)) {
      return prefixWord + this.classicalInflectionPluralizationService.getSecondValue(suffixWord);
    }

    newSuffixWord = PluralizationServiceUtil.TryInflectOnSuffixInWord(
      suffixWord,
      ["trix"],
      (s) => `${s.slice(0, -1)}ces`,
    );
    if (newSuffixWord !== null) {
      return prefixWord + newSuffixWord;
    }

    newSuffixWord = PluralizationServiceUtil.TryInflectOnSuffixInWord(suffixWord, ["eau", "ieu"], (s) => `${s}x`);
    if (newSuffixWord !== null) {
      return prefixWord + newSuffixWord;
    }

    if (this.wordsEndingWithInxAnxYnxPluralizationService.existsInFirst(suffixWord)) {
      return prefixWord + this.wordsEndingWithInxAnxYnxPluralizationService.getSecondValue(suffixWord);
    }

    // [cs]h and ss that take es as plural form
    newSuffixWord = PluralizationServiceUtil.TryInflectOnSuffixInWord(suffixWord, ["ch", "sh", "ss"], (s) => `${s}es`);
    if (newSuffixWord !== null) {
      return prefixWord + newSuffixWord;
    }

    // f, fe that take ves as plural form
    newSuffixWord = PluralizationServiceUtil.TryInflectOnSuffixInWord(
      suffixWord,
      ["alf", "elf", "olf", "eaf", "arf"],
      (s) => (endsWithIgnoreCase(s, "deaf") ? s : `${s.slice(0, -1)}ves`),
    );
    if (newSuffixWord !== null) {
      return prefixWord + newSuffixWord;
    }

    newSuffixWord = PluralizationServiceUtil.TryInflectOnSuffixInWord(
      suffixWord,
      ["nife", "life", "wife"],
      (s) => `${s.slice(0, -2)}ves`,
    );
    if (newSuffixWord !== null) {
      return prefixWord + newSuffixWord;
    }

    // y takes ys as plural form if preceded by a vowel, but ies if preceded by a consonant, e.g. stays, skies
    newSuffixWord = PluralizationServiceUtil.TryInflectOnSuffixInWord(
      suffixWord,
      ["ay", "ey", "iy", "oy", "uy"],
      (s) => `${s}s`,
    );
    if (newSuffixWord !== null) {
      return prefixWord + newSuffixWord;
    }

    //
    if (endsWithIgnoreCase(suffixWord, "y")) {
      return prefixWord + suffixWord.slice(0, -1) + "ies";
    }

    // handle some of the words o -> os, and [vowel]o -> os, and the rest are o->oes
    if (this.oSuffixPluralizationService.existsInFirst(suffixWord)) {
      return prefixWord + this.oSuffixPluralizationService.getSecondValue(suffixWord);
    }

    newSuffixWord = PluralizationServiceUtil.TryInflectOnSuffixInWord(
      suffixWord,
      ["ao", "eo", "io", "oo", "uo"],
      (s) => `${s}s`,
    );
    if (newSuffixWord !== null) {
      return prefixWord + newSuffixWord;
    }

    if (endsWithIgnoreCase(suffixWord, "o") || endsWithIgnoreCase(suffixWord, "s")) {
      return `${prefixWord}${suffixWord}es`;
    }

    if (endsWithIgnoreCase(suffixWord, "x")) {
      return `${prefixWord}${suffixWord}es`;
    }

    // cats, bags, hats, speakers
    return `${prefixWord}${suffixWord}s`;
  }

  public singularize(word: string): string {
    if (!word) {
      return word;
    }

    // split it up.
    const de = deconstruct(word);

    // singularize the last word only
    de[de.length - 1] = this.capitalize(de.last, (w) => this.internalSingularize(w));

    // return the pascal cased whole thing.
    return pascalCase(de);
  }

  private internalSingularize(word: string): string {
    // words that we know of
    if (this.userDictionary.existsInSecond(word)) {
      return this.userDictionary.getFirstValue(word);
    }

    if (this.isNoOpWord(word)) {
      return word;
    }

    const { prefixWord, suffixWord } = this.getSuffixWord(word);

    if (this.isNoOpWord(suffixWord)) {
      return prefixWord + suffixWord;
    }

    // handle the word that is the same as the plural form
    if (this.isUninflective(suffixWord)) {
      return prefixWord + suffixWord;
    }

    // if word is one of the known singular words, then just return

    if (this.knownSingluarWords.includes(suffixWord.toLowerCase())) {
      return prefixWord + suffixWord;
    }

    // handle simple irregular verbs, e.g. was -> were
    if (this.irregularVerbPluralizationService.existsInSecond(suffixWord)) {
      return prefixWord + this.irregularVerbPluralizationService.getFirstValue(suffixWord);
    }

    // handle irregular plurals, e.g. "ox" -> "oxen"
    if (this.irregularPluralsPluralizationService.existsInSecond(suffixWord)) {
      return prefixWord + this.irregularPluralsPluralizationService.getFirstValue(suffixWord);
    }

    // handle singluarization for words ending with sis and pluralized to ses,
    // e.g. "ses" -> "sis"
    if (this.wordsEndingWithSisPluralizationService.existsInSecond(suffixWord)) {
      return prefixWord + this.wordsEndingWithSisPluralizationService.getFirstValue(suffixWord);
    }

    // handle words ending with se, e.g. "ses" -> "se"
    if (this.wordsEndingWithSePluralizationService.existsInSecond(suffixWord)) {
      return prefixWord + this.wordsEndingWithSePluralizationService.getFirstValue(suffixWord);
    }

    // handle words ending with sus, e.g. "suses" -> "sus"
    if (this.wordsEndingWithSusPluralizationService.existsInSecond(suffixWord)) {
      return prefixWord + this.wordsEndingWithSusPluralizationService.getFirstValue(suffixWord);
    }

    let newSuffixWord: string | null;
    newSuffixWord = PluralizationServiceUtil.TryInflectOnSuffixInWord(
      suffixWord,
      ["men"],
      (s) => `${s.slice(0, -2)}an`,
    );
    if (newSuffixWord !== null) {
      return prefixWord + newSuffixWord;
    }

    // handle irregular inflections for common suffixes, e.g. "mouse" -> "mice"
    newSuffixWord = PluralizationServiceUtil.TryInflectOnSuffixInWord(
      suffixWord,
      ["lice", "mice"],
      (s) => `${s.slice(0, -3)}ouse`,
    );
    if (newSuffixWord !== null) {
      return prefixWord + newSuffixWord;
    }

    newSuffixWord = PluralizationServiceUtil.TryInflectOnSuffixInWord(
      suffixWord,
      ["teeth"],
      (s) => `${s.slice(0, -4)}ooth`,
    );
    if (newSuffixWord !== null) {
      return prefixWord + newSuffixWord;
    }

    newSuffixWord = PluralizationServiceUtil.TryInflectOnSuffixInWord(
      suffixWord,
      ["geese"],
      (s) => `${s.slice(0, -4)}oose`,
    );
    if (newSuffixWord !== null) {
      return prefixWord + newSuffixWord;
    }

    newSuffixWord = PluralizationServiceUtil.TryInflectOnSuffixInWord(
      suffixWord,
      ["feet"],
      (s) => `${s.slice(0, -3)}oot`,
    );
    if (newSuffixWord !== null) {
      return prefixWord + newSuffixWord;
    }

    newSuffixWord = PluralizationServiceUtil.TryInflectOnSuffixInWord(
      suffixWord,
      ["zoa"],
      (s) => `${s.slice(0, -2)}oon`,
    );
    if (newSuffixWord !== null) {
      return prefixWord + newSuffixWord;
    }

    // [cs]h and ss that take es as plural form, this is being moved up since the sses will be override by the ses
    newSuffixWord = PluralizationServiceUtil.TryInflectOnSuffixInWord(suffixWord, ["ches", "shes", "sses"], (s) =>
      s.slice(0, -2),
    );
    if (newSuffixWord !== null) {
      return prefixWord + newSuffixWord;
    }

    // handle assimilated classical inflections, e.g. vertebra -> vertebrae
    if (this.assimilatedClassicalInflectionPluralizationService.existsInSecond(suffixWord)) {
      return prefixWord + this.assimilatedClassicalInflectionPluralizationService.getFirstValue(suffixWord);
    }

    // Handle the classical variants of modern inflections
    //
    if (this.classicalInflectionPluralizationService.existsInSecond(suffixWord)) {
      return prefixWord + this.classicalInflectionPluralizationService.getFirstValue(suffixWord);
    }

    newSuffixWord = PluralizationServiceUtil.TryInflectOnSuffixInWord(
      suffixWord,
      ["trices"],
      (s) => `${s.slice(0, -3)}x`,
    );
    if (newSuffixWord !== null) {
      return prefixWord + newSuffixWord;
    }

    newSuffixWord = PluralizationServiceUtil.TryInflectOnSuffixInWord(suffixWord, ["eaux", "ieux"], (s) =>
      s.slice(0, -1),
    );
    if (newSuffixWord !== null) {
      return prefixWord + newSuffixWord;
    }

    if (this.wordsEndingWithInxAnxYnxPluralizationService.existsInSecond(suffixWord)) {
      return prefixWord + this.wordsEndingWithInxAnxYnxPluralizationService.getFirstValue(suffixWord);
    }

    // f, fe that take ves as plural form
    newSuffixWord = PluralizationServiceUtil.TryInflectOnSuffixInWord(
      suffixWord,
      ["alves", "elves", "olves", "eaves", "arves"],
      (s) => `${s.slice(0, -3)}f`,
    );
    if (newSuffixWord !== null) {
      return prefixWord + newSuffixWord;
    }

    newSuffixWord = PluralizationServiceUtil.TryInflectOnSuffixInWord(
      suffixWord,
      ["nives", "lives", "wives"],
      (s) => `${s.slice(0, -3)}fe`,
    );
    if (newSuffixWord !== null) {
      return prefixWord + newSuffixWord;
    }

    // y takes ys as plural form if preceded by a vowel, but ies if preceded by a consonant, e.g. stays, skies
    newSuffixWord = PluralizationServiceUtil.TryInflectOnSuffixInWord(
      suffixWord,
      ["ays", "eys", "iys", "oys", "uys"],
      (s) => s.slice(0, -1),
    );
    if (newSuffixWord !== null) {
      return prefixWord + newSuffixWord;
    }

    //

    if (endsWithIgnoreCase(suffixWord, "ies")) {
      return prefixWord + suffixWord.slice(0, -3) + "y";
    }

    // handle some of the words o -> os, and [vowel]o -> os, and the rest are o->oes
    if (this.oSuffixPluralizationService.existsInSecond(suffixWord)) {
      return prefixWord + this.oSuffixPluralizationService.getFirstValue(suffixWord);
    }

    newSuffixWord = PluralizationServiceUtil.TryInflectOnSuffixInWord(
      suffixWord,
      ["aos", "eos", "ios", "oos", "uos"],
      (s) => s.slice(0, -1),
    );
    if (newSuffixWord !== null) {
      return prefixWord + newSuffixWord;
    }

    //

    newSuffixWord = PluralizationServiceUtil.TryInflectOnSuffixInWord(suffixWord, ["ces"], (s) => s.slice(0, -1));
    if (newSuffixWord !== null) {
      return prefixWord + newSuffixWord;
    }

    newSuffixWord = PluralizationServiceUtil.TryInflectOnSuffixInWord(suffixWord, ["ces", "ses", "xes"], (s) =>
      s.slice(0, -2),
    );
    if (newSuffixWord !== null) {
      return prefixWord + newSuffixWord;
    }

    if (endsWithIgnoreCase(suffixWord, "oes")) {
      return prefixWord + suffixWord.slice(0, -2);
    }

    if (endsWithIgnoreCase(suffixWord, "ss")) {
      return prefixWord + suffixWord;
    }

    if (endsWithIgnoreCase(suffixWord, "s")) {
      return prefixWord + suffixWord.slice(0, -1);
    }

    // word is a singlar
    return prefixWord + suffixWord;
  }

  /// <summary>
  /// captalize the return word if the parameter is capitalized
  /// if word is "Table", then return "Tables"
  /// </summary>
  /// <param name="word"></param>
  /// <param name="action"></param>
  /// <returns></returns>
  private capitalize(word: string, action: (s: string) => string) {
    const result = action(word);

    if (this.isCapitalized(word)) {
      if (result.length === 0) {
        return result;
      }
      return result.charAt(0).toUpperCase() + result.substr(1);
    } else {
      return result;
    }
  }

  /// <summary>
  /// separate one combine word in to two parts, prefix word and the last word(suffix word)
  /// </summary>
  /// <param name="word"></param>
  /// <param name="prefixWord"></param>
  /// <returns></returns>
  private getSuffixWord(word: string): { prefixWord: string; suffixWord: string } {
    // use the last space to separate the words
    const lastSpaceIndex = word.lastIndexOf(" ");
    return {
      prefixWord: word.substr(0, lastSpaceIndex + 1),
      suffixWord: word.substr(lastSpaceIndex + 1),
    };
    //
  }

  private isCapitalized(word: string): boolean {
    if (word === "") {
      return false;
    }
    return word.charAt(0) == word.charAt(0).toUpperCase();
  }

  private isAlphabets(word: string): boolean {
    // return false when the word is "[\s]*" or leading or tailing with spaces
    // or contains non alphabetical characters
    if (word === "" || word !== word.trim() || /[^a-zA-Z\\s]/.test(word)) {
      return false;
    } else {
      return true;
    }
  }

  private isUninflective(word: string): boolean {
    if (
      PluralizationServiceUtil.DoesWordContainSuffix(word, this.uninflectiveSuffixList) ||
      (word.toLowerCase() !== word && word.endsWith("ese")) ||
      this.uninflectiveWordList.includes(word.toLowerCase())
    ) {
      return true;
    } else {
      return false;
    }
  }

  /// <summary>
  /// return true when the word is "[\s]*" or leading or tailing with spaces
  /// or contains non alphabetical characters
  /// </summary>
  /// <param name="word"></param>
  /// <returns></returns>
  private isNoOpWord(word: string): boolean {
    if (!this.isAlphabets(word) || word.length <= 1 || this.pronounList.includes(word.toLowerCase())) {
      return true;
    } else {
      return false;
    }
  }

  /// <summary>
  /// This method allow you to add word to internal PluralizationService of English.
  /// If the singluar or the plural value was already added by this method, then an ArgumentException will be thrown.
  /// </summary>
  /// <param name="singular"></param>
  /// <param name="plural"></param>
  public addWord(singular: string, plural: string): void {
    if (this.userDictionary.existsInSecond(plural)) {
      throw new Error(`The plural value '${plural}' already exists in the user-defined dictionary.`);
    } else if (this.userDictionary.existsInFirst(singular)) {
      throw new Error(`The singular value '${singular}' already exists in the user-defined dictionary.`);
    } else {
      this.userDictionary.addValue(singular, plural);
    }
  }
}
