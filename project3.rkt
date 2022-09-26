#lang typed/racket
;;Andrew Chen
;;Project 3
;;CS 151 Autumn 2021
(require "../include/cs151-core.rkt")
(require "../include/cs151-image.rkt")
(require "../include/cs151-universe.rkt")
(require typed/test-engine/racket-tests)

(define-struct (Pairof A B)
  ([x : A]
   [y : B]))

(define-type (Optional T)
  (U 'None (Some T)))

(define-struct (Some T)
  ([value : T]))

(define-type TickInterval
  Positive-Exact-Rational)

(define-struct Date
  ([month : Integer]
   [day : Integer]
   [year : Integer]))

(define-type Stroke
  (U 'Freestyle 'Backstroke 'Breaststroke 'Butterfly))

(define-struct Event
  ([gender : (U 'Men 'Women)]
   [race-distance : Integer]
   [stroke : Stroke]
   [name : String]
   [date : Date]))

(define-type Country
  (U 'AFG 'ALB 'ALG 'AND 'ANG 'ANT 'ARG 'ARM 'ARU 'ASA 'AUS 'AUT 'AZE 'BAH
     'BAN 'BAR 'BDI 'BEL 'BEN 'BER 'BHU 'BIH 'BIZ 'BLR 'BOL 'BOT 'BRA 'BRN
     'BRU 'BUL 'BUR 'CAF 'CAM 'CAN 'CAY 'CGO 'CHA 'CHI 'CHN 'CIV 'CMR 'COD
     'COK 'COL 'COM 'CPV 'CRC 'CRO 'CUB 'CYP 'CZE 'DEN 'DJI 'DMA 'DOM 'ECU
     'EGY 'ERI 'ESA 'ESP 'EST 'ETH 'FIJ 'FIN 'FRA 'FSM 'GAB 'GAM 'GBR 'GBS
     'GEO 'GEQ 'GER 'GHA 'GRE 'GRN 'GUA 'GUI 'GUM 'GUY 'HAI 'HON 'HUN 'INA
     'IND 'IRI 'IRL 'IRQ 'ISL 'ISR 'ISV 'ITA 'IVB 'JAM 'JOR 'JPN 'KAZ 'KEN
     'KGZ 'KIR 'KOR 'KOS 'KSA 'KUW 'LAO 'LAT 'LBA 'LBN 'LBR 'LCA 'LES 'LIE
     'LTU 'LUX 'MAD 'MAR 'MAS 'MAW 'MDA 'MDV 'MEX 'MGL 'MHL 'MKD 'MLI 'MLT
     'MNE 'MON 'MOZ 'MRI 'MTN 'MYA 'NAM 'NCA 'NED 'NEP 'NGR 'NIG 'NOR 'NRU
     'NZL 'OMA 'PAK 'PAN 'PAR 'PER 'PHI 'PLE 'PLW 'PNG 'POL 'POR 'PRK 'QAT
     'ROU 'RSA 'ROC 'RUS 'RWA 'SAM 'SEN 'SEY 'SGP 'SKN 'SLE 'SLO 'SMR 'SOL
     'SOM 'SRB 'SRI 'SSD 'STP 'SUD 'SUI 'SUR 'SVK 'SWE 'SWZ 'SYR 'TAN 'TGA
     'THA 'TJK 'TKM 'TLS 'TOG 'TTO 'TUN 'TUR 'TUV 'UAE 'UGA 'UKR 'URU 'USA
     'UZB 'VAN 'VEN 'VIE 'VIN 'YEM 'ZAM 'ZIM))

(define-struct IOC
  ([abbrev : Country]
   [country : String]))

(define-struct Swimmer
  ([lname : String]
   [fname : String]
   [country : Country]
   [height : Real]))

(define-struct Result
  ([swimmer : Swimmer]
   [splits : (Listof Real)]))

(define-type Mode
  (U 'choose 'running 'paused 'done))

(define-struct (KeyValue K V)
  ([key : K]
   [value : V]))
         
(define-struct (Association K V)
  ([key=? : (K K -> Boolean)]
   [data : (Listof (KeyValue K V))]))

(define-struct FileChooser
  ([directory : String]
   [chooser : (Association Char String)]))
;; a map of chars #\a, #\b etc. to file names

(define-struct Sim
  ([mode : Mode]
   [event : Event]
   [tick-rate : TickInterval]
   [sim-speed : (U '1x '2x '4x '8x)]
   [sim-clock : Real]
   [pixels-per-meter : Integer]
   [pool : (Listof Result)] ;; in lane order
   [labels : Image] ;; corresponding to lane order
   [ranks : (Listof Integer)] ;; in lane order
   [end-time : Real]
   [file-chooser : (Optional FileChooser)]))

(define-struct Position
  ([x-position : Real]
   [direction : (U 'east 'west 'finished)]))

(: ioc-abbrevs (Listof IOC))
(define ioc-abbrevs
  (list (IOC 'AFG "Afghanistan")
        (IOC 'ALB "Albania")
        (IOC 'ALG "Algeria")
        (IOC 'AND "Andorra")
        (IOC 'ANG "Angola")
        (IOC 'ANT "Antigua Barbuda")
        (IOC 'ARG "Argentina")
        (IOC 'ARM "Armenia")
        (IOC 'ARU "Aruba")
        (IOC 'ASA "American Samoa")
        (IOC 'AUS "Australia")
        (IOC 'AUT "Austria")
        (IOC 'AZE "Azerbaijan")
        (IOC 'BAH "Bahamas")
        (IOC 'BAN "Bangladesh")
        (IOC 'BAR "Barbados")
        (IOC 'BDI "Burundi")
        (IOC 'BEL "Belgium")
        (IOC 'BEN "Benin")
        (IOC 'BER "Bermuda")
        (IOC 'BHU "Bhutan")
        (IOC 'BIH "Bosnia Herzegovina")
        (IOC 'BIZ "Belize")
        (IOC 'BLR "Belarus")
        (IOC 'BOL "Bolivia")
        (IOC 'BOT "Botswana")
        (IOC 'BRA "Brazil")
        (IOC 'BRN "Bahrain")
        (IOC 'BRU "Brunei")
        (IOC 'BUL "Bulgaria")
        (IOC 'BUR "Burkina Faso")
        (IOC 'CAF "Central African Republic")
        (IOC 'CAM "Cambodia")
        (IOC 'CAN "Canada")
        (IOC 'CAY "Cayman Islands")
        (IOC 'CGO "Congo Brazzaville")
        (IOC 'CHA "Chad")
        (IOC 'CHI "Chile")
        (IOC 'CHN "China")
        (IOC 'CIV "Cote dIvoire")
        (IOC 'CMR "Cameroon")
        (IOC 'COD "Congo Kinshasa")
        (IOC 'COK "Cook Islands")
        (IOC 'COL "Colombia")
        (IOC 'COM "Comoros")
        (IOC 'CPV "Cape Verde")
        (IOC 'CRC "Costa Rica")
        (IOC 'CRO "Croatia")
        (IOC 'CUB "Cuba")
        (IOC 'CYP "Cyprus")
        (IOC 'CZE "Czechia")
        (IOC 'DEN "Denmark")
        (IOC 'DJI "Djibouti")
        (IOC 'DMA "Dominica")
        (IOC 'DOM "Dominican Republic")
        (IOC 'ECU "Ecuador")
        (IOC 'EGY "Egypt")
        (IOC 'ERI "Eritrea")
        (IOC 'ESA "El Salvador")
        (IOC 'ESP "Spain")
        (IOC 'EST "Estonia")
        (IOC 'ETH "Ethiopia")
        (IOC 'FIJ "Fiji")
        (IOC 'FIN "Finland")
        (IOC 'FRA "France")
        (IOC 'FSM "Micronesia")
        (IOC 'GAB "Gabon")
        (IOC 'GAM "Gambia")
        (IOC 'GBR "United Kingdom")
        (IOC 'GBS "Guinea-Bissau")
        (IOC 'GEO "Georgia")
        (IOC 'GEQ "Equatorial Guinea")
        (IOC 'GER "Germany")
        (IOC 'GHA "Ghana")
        (IOC 'GRE "Greece")
        (IOC 'GRN "Grenada")
        (IOC 'GUA "Guatemala")
        (IOC 'GUI "Guinea")
        (IOC 'GUM "Guam")
        (IOC 'GUY "Guyana")
        (IOC 'HAI "Haiti")
        (IOC 'HON "Honduras")
        (IOC 'HUN "Hungary")
        (IOC 'INA "Indonesia")
        (IOC 'IND "India")
        (IOC 'IRI "Iran")
        (IOC 'IRL "Ireland")
        (IOC 'IRQ "Iraq")
        (IOC 'ISL "Iceland")
        (IOC 'ISR "Israel")
        (IOC 'ISV "US Virgin Islands")
        (IOC 'ITA "Italy")
        (IOC 'IVB "British Virgin Islands")
        (IOC 'JAM "Jamaica")
        (IOC 'JOR "Jordan")
        (IOC 'JPN "Japan")
        (IOC 'KAZ "Kazakhstan")
        (IOC 'KEN "Kenya")
        (IOC 'KGZ "Kyrgyzstan")
        (IOC 'KIR "Kiribati")
        (IOC 'KOR "South Korea")
        (IOC 'KOS "Kosovo")
        (IOC 'KSA "Saudi Arabia")
        (IOC 'KUW "Kuwait")
        (IOC 'LAO "Laos")
        (IOC 'LAT "Latvia")
        (IOC 'LBA "Libya")
        (IOC 'LBN "Lebanon")
        (IOC 'LBR "Liberia")
        (IOC 'LCA "St Lucia")
        (IOC 'LES "Lesotho")
        (IOC 'LIE "Liechtenstein")
        (IOC 'LTU "Lithuania")
        (IOC 'LUX "Luxembourg")
        (IOC 'MAD "Madagascar")
        (IOC 'MAR "Morocco")
        (IOC 'MAS "Malaysia")
        (IOC 'MAW "Malawi")
        (IOC 'MDA "Moldova")
        (IOC 'MDV "Maldives")
        (IOC 'MEX "Mexico")
        (IOC 'MGL "Mongolia")
        (IOC 'MHL "Marshall Islands")
        (IOC 'MKD "North Macedonia")
        (IOC 'MLI "Mali")
        (IOC 'MLT "Malta")
        (IOC 'MNE "Montenegro")
        (IOC 'MON "Monaco")
        (IOC 'MOZ "Mozambique")
        (IOC 'MRI "Mauritius")
        (IOC 'MTN "Mauritania")
        (IOC 'MYA "Myanmar Burma")
        (IOC 'NAM "Namibia")
        (IOC 'NCA "Nicaragua")
        (IOC 'NED "Netherlands")
        (IOC 'NEP "Nepal")
        (IOC 'NGR "Nigeria")
        (IOC 'NIG "Niger")
        (IOC 'NOR "Norway")
        (IOC 'NRU "Nauru")
        (IOC 'NZL "New Zealand")
        (IOC 'OMA "Oman")
        (IOC 'PAK "Pakistan")
        (IOC 'PAN "Panama")
        (IOC 'PAR "Paraguay")
        (IOC 'PER "Peru")
        (IOC 'PHI "Philippines")
        (IOC 'PLE "Palestinian Territories")
        (IOC 'PLW "Palau")
        (IOC 'PNG "Papua New Guinea")
        (IOC 'POL "Poland")
        (IOC 'POR "Portugal")
        (IOC 'PRK "North Korea")
        (IOC 'QAT "Qatar")
        (IOC 'ROU "Romania")
        (IOC 'RSA "South Africa")
        (IOC 'ROC "Russia")
        (IOC 'RUS "Russia")
        (IOC 'RWA "Rwanda")
        (IOC 'SAM "Samoa")
        (IOC 'SEN "Senegal")
        (IOC 'SEY "Seychelles")
        (IOC 'SGP "Singapore")
        (IOC 'SKN "St Kitts Nevis")
        (IOC 'SLE "Sierra Leone")
        (IOC 'SLO "Slovenia")
        (IOC 'SMR "San Marino")
        (IOC 'SOL "Solomon Islands")
        (IOC 'SOM "Somalia")
        (IOC 'SRB "Serbia")
        (IOC 'SRI "Sri Lanka")
        (IOC 'SSD "South Sudan")
        (IOC 'STP "Sao Tome Principe")
        (IOC 'SUD "Sudan")
        (IOC 'SUI "Switzerland")
        (IOC 'SUR "Suriname")
        (IOC 'SVK "Slovakia")
        (IOC 'SWE "Sweden")
        (IOC 'SWZ "Eswatini")
        (IOC 'SYR "Syria")
        (IOC 'TAN "Tanzania")
        (IOC 'TGA "Tonga")
        (IOC 'THA "Thailand")
        (IOC 'TJK "Tajikistan")
        (IOC 'TKM "Turkmenistan")
        (IOC 'TLS "Timor Leste")
        (IOC 'TOG "Togo")
        (IOC 'TTO "Trinidad Tobago")
        (IOC 'TUN "Tunisia")
        (IOC 'TUR "Turkey")
        (IOC 'TUV "Tuvalu")
        (IOC 'UAE "United Arab Emirates")
        (IOC 'UGA "Uganda")
        (IOC 'UKR "Ukraine")
        (IOC 'URU "Uruguay")
        (IOC 'USA "United States")
        (IOC 'UZB "Uzbekistan")
        (IOC 'VAN "Vanuatu")
        (IOC 'VEN "Venezuela")
        (IOC 'VIE "Vietnam")
        (IOC 'VIN "St Vincent Grenadines")
        (IOC 'YEM "Yemen")
        (IOC 'ZAM "Zambia")
        (IOC 'ZIM "Zimbabwe")))

(define tokyo-w-50m
  (Event 'Women 50 'Freestyle "Tokyo Olympics 2020" (Date 7 31 2021)))

(define mckeon (Swimmer "McKeon" "Emma" 'AUS 1.78)) ;; 23.81
(define sjoestroem (Swimmer "Sjoestroem" "Sarah" 'SWE 1.82)) ;; 24.07
(define blume (Swimmer "Blume" "Pernille" 'DEN 1.70)) ;; 24.21
(define kromowidjojo (Swimmer "Kromowidjojo" "Ranomi" 'NED 1.79)) ;; 24.30
(define wasick (Swimmer "Wasick" "Katarzyna" 'POL 1.78)) ;; 24.32
(define wu (Swimmer "Wu" "Qingfeng" 'CHN 1.70)) ;; 24.32
(define campbell (Swimmer "Campbell" "Cate" 'AUS 1.86)) ;; 24.36
(define weitzeil (Swimmer "Weitzeil" "Abbey" 'USA 1.78)) ;; 24.41

(: worldleaders : (Listof Result))
(define worldleaders
  (list
   (Result (Swimmer "Macron" "Emmanuel" 'FRA 1.75)(list 8 9))
   (Result (Swimmer "Trudeau" "Justin" 'CAN 1.88) (list 10 6.9))))

(: w50 : (Listof Result))
(define w50
  (list
   (Result kromowidjojo (list 24.30))
   (Result wasick (list 24.32))
   (Result sjoestroem (list 24.07))
   (Result mckeon (list 23.81))
   (Result blume (list 24.21))
   (Result weitzeil (list 24.41))
   (Result campbell (list 24.36))
   (Result wu (list 24.32))))

(define tokyo-m-200m-b
  (Event 'Men 200 'Backstroke "Tokyo Olympics 2020" (Date 7 29 2021)))

(define rylov (Swimmer "Rylov" "Evgeny" 'ROC 1.85))
(define murphy (Swimmer "Murphy" "Ryan" 'USA 1.93))
(define greenbank (Swimmer "Greenbank" "Luke" 'GBR 1.83))
(define mefford (Swimmer "Mefford" "Bryce" 'USA 1.91))
(define telegdy (Swimmer "Telegdy" "Adam" 'HUN 1.93))
(define kawecki (Swimmer "Kawecki" "Radoslaw" 'POL 1.85))
(define irie (Swimmer "Irie" "Ryosuke" 'JPN 1.78))
(define garcia (Swimmer "Garcia Saiz" "Nicolas" 'ESP 1.93))

(: m200 (Listof Result))
(define m200
  (list
   (Result kawecki (list 27.89 29.65 29.23 29.62))
   (Result garcia (list 27.66 29.40 30.49 31.51))
   (Result murphy (list 27.11 28.52 29.02 29.50))
   (Result rylov (list 26.81 28.37 28.75 29.34))
   (Result greenbank (list 27.02 28.70 29.36 29.64))
   (Result telegdy (list 27.57 29.39 29.75 29.44))   
   (Result mefford (list 27.19 28.92 29.21 30.17))
   (Result irie (list 27.48 29.64 30.18 30.02))))


;-------------------


(: find-assoc : All (K V) K (Association K V) -> (Optional V))
;; given a key and an association,
;; return the corresponding value, if there is one
;; returns first matching key starting at head of list
(define (find-assoc k assoc)
  (local {(define datalist (Association-data assoc))
          (define keyequal? (Association-key=? assoc))}
  (match datalist
    ['() 'None]
    [(cons first rest)
     (if (keyequal? (KeyValue-key first) k)
         (Some (KeyValue-value first))
         (find-assoc k (Association keyequal? rest)))])))

(check-expect (find-assoc "andrew"
                          (createdictionary
                           (list "andrew:chen" "blues:" "clue:me")
                           #\:)) (Some "chen"))
(check-expect (find-assoc "andrews"
                          (createdictionary
                           (list "andrew:chen" "blues:" "clue:me")
                           #\:)) 'None)
(check-expect (find-assoc "blues"
                          (createdictionary
                           (list "andrew:chen" "blues:" "clue:me")
                           #\:)) (Some ""))


(: stringkeyvalue=? : (KeyValue String String) (KeyValue String String)
   -> Boolean)
;; returns true if two string KeyValues are the same, with same defined
;; as having the same key strings and same value strings
(define (stringkeyvalue=? k1 k2)
  (and (string=? (KeyValue-key k1)(KeyValue-key k2))
       (string=? (KeyValue-value k1)(KeyValue-value k2))))


(: remove-from-assoc : (KeyValue String String)(Association String String)
   -> (Association String String))
;; removes the given String KeyValue from the first String Association,
;; if it exists. 
;; will only remove first instance it encounters, starting from the beginning
;; of the list
(define (remove-from-assoc v d)
  (local {(: r-f-a-recursionhelper : (KeyValue String String)
             (Association String String) (Listof (KeyValue String String))
             -> (Association String String))
          ;; Uses a Listof KeyValues helps keep the values
          ;; already traversed for recursion purposes.
          (define (r-f-a-recursionhelper value dict holder)
            (local {(define datalist (Association-data dict))}
            (match datalist
              ['() (Association string=? holder)]
              [(cons first rest)
               (if (stringkeyvalue=? value first)
                   (Association string=? (append holder rest))
                   (r-f-a-recursionhelper value (Association string=? rest)
                                      (append holder (list first))))])))}
    (r-f-a-recursionhelper v d '())))


(: split : Char String -> (Listof String))
;; split a string around the given character
;; ex: (split #\x "abxcdxyyz") -> (list "ab" "cd" "yyz")
;; ex: (split #\, "Chicago,IL,60637") -> (list "Chicago" "IL" "60637")
;; ex: (split #\: "abcd") -> (list "abcd")
(define (split c s)
  (local {(: worduntilsplit : String String -> (Pairof String String))
          ;; gets the current word until the string should be split
          (define (worduntilsplit current rest)
            (cond
              [(string=? rest "") (Pairof current rest)]
              [(char=? (list-ref (string->list (substring rest 0 1))0) c)
               (Pairof current (substring rest 1))]
              [else (worduntilsplit (string-append current (substring rest 0 1))
                                    (substring rest 1))]))
          (define curpair (worduntilsplit "" s))}
    (append (list (Pairof-x curpair)) (if (string=? "" (Pairof-y curpair))
                                          '()
                                          (split c (Pairof-y curpair))))))

(check-expect (split #\x "abxcdxyyz") (list "ab" "cd" "yyz"))
(check-expect (split #\, "Chicago,IL,60637")(list "Chicago" "IL" "60637"))
(check-expect (split #\: "abcd")(list "abcd"))


(: createdictionary : (Listof String) Char ->(Association String String))
;; creates an association from String list given by swm file
;; using the string before the first instance of given char as the key,
;; and the string after the char as the value, e.g. if char is #\:, then entry
;; "name:andrew" in a list has key "name" and value "andrew".
;; If the char is in the string multiple times it will cause issues but these
;; lines in the swm files are garbage and not relevant to the project,
;; or the function will not utilized in such a manner.
(define (createdictionary givenlist ch)
  (local {(: createdictionary-helper : (Listof String)
             (Association String String) Char ->(Association String String))
          ;; recursive helper function that also has an extra association
          ;; input to help store the information
         (define (createdictionary-helper l currentdict c)
           (match l
             ['() currentdict]
             [(cons first rest)
              (local {(define splittedline (split c first))}
                (createdictionary-helper
                 rest
                 (Association string=?
                              (append
                               (Association-data currentdict)
                               (list
                                (KeyValue (list-ref splittedline 0)
                                          (foldl string-append ""
                                                 (match splittedline
                                                   ['() '()]
                                                   [(cons first2 rest2) rest2])
                                                 )))))c))]))}
    (createdictionary-helper givenlist (Association string=? '()) ch)))


(: dict-to-list : (Association String String) String -> (Listof String))
;; takes an association and a key and returns all values in the association
;; that has that key
(define (dict-to-list assoc k)
  (local {(: dict-to-list-helper :
             (Pairof (Association String String)(Listof String)) String
             -> (Pairof (Association String String)(Listof String)))
          ;; recursive helper function.
          ;; takes an association and creates a Pairof with an Association with
          ;; the elements whose key is the given string removed,
          ;; and a list of all elements whose key is the
          ;; given string, e.g. if the key is "result", this function will
          ;; return a Pairof  with the Association with the elements with key
          ;; "result" removed and a list of all values of the association
          ;; with key "result".
          (define (dict-to-list-helper dictpair key)
            (local {(define dict (Pairof-x dictpair))
                    (define currlist (Pairof-y dictpair))}
              (match (find-assoc key dict)
                ['None dictpair]
                [(Some string) (dict-to-list-helper
                                (Pairof (remove-from-assoc (KeyValue key string)
                                                           dict)
                                        (append currlist (list string)))
                                key)])))}
    (Pairof-y (dict-to-list-helper (Pairof assoc '()) k))))


(: build-event : (Association String String)-> Event)
;; builds an event from data stored in an association
;; we assume exactly one of "gender:w" or "gender:m" appears in the file
;; where "m" and "w" are lowercase ONLY. Similar for other GIGO cases
(define (build-event dict)
  (local {(define gender
            (match (find-assoc "gender" dict)
              [(Some gend)(if (string=? "w" gend)'Women 'Men)]))
          (define race-distance
            (match (find-assoc "distance" dict)
              [(Some dist) (cast (string->number dist) Integer)]))
          (define stroke
            (match (find-assoc "stroke" dict)
              [(Some stk) (cast (string->symbol stk) Stroke)]))
          (define name
            (match (find-assoc "event" dict)
              [(Some nme) nme]))
          (define date-as-list
            (match (find-assoc "date" dict)
              [(Some dte)(split #\| dte)]))
          (define date (Date (cast(string->number (list-ref date-as-list 1))Int)
                             (cast(string->number (list-ref date-as-list 0))Int)
                             (cast(string->number(list-ref date-as-list 2))
                                  Int)))}
    (Event gender race-distance stroke name date)))


(: build-results : (Association String String) -> (Listof Result))
;; builds a Result from a given association created from the swm file
;; assume GIGO
(define (build-results dict)
  (local {(define rawlistofresults (dict-to-list dict "result"))
          (define listofresults
            (map (lambda ([s : String])(split #\| s)) rawlistofresults))
          (: firstnuminlist<? : (Listof String)(Listof String) -> Boolean)
          ;; for two lists where the first element is a number, compare
          ;; whether the first element of the first list is strictly less than
          ;;the first element of the second list
          (define (firstnuminlist<? l1 l2)
            (match* (l1 l2)
              [((cons first1 x)(cons first2 y)) (< (cast
                                                    (string->number first1)
                                                    Real)
                                                   (cast 
                                                    (string->number first2)
                                                    Real))]))
          (define sortedlistofresults (quick-sort listofresults
                                                 firstnuminlist<?))
          (: build-results-helper : (Listof (Listof String)) -> (Listof Result))
          ;; recursive helper to build results based on a sorted list of
          ;; strings containing info about the results
          (define (build-results-helper l)
            (match l
              ['() '()]
              [(cons first rest)
               (append
                (list (Result (Swimmer
                         (list-ref first 1)
                         (list-ref first 2)
                         (cast (string->symbol (list-ref first 3)) Country)
                         (cast (string->number (list-ref first 4)) Real))
                        (map (lambda ([s : String])
                               (cast (string->number s) Real))
                             (split #\, (list-ref first 5)))))
                (build-results-helper rest))]))}
    (build-results-helper sortedlistofresults)))
          

(: sim-from-file : TickInterval Integer String -> Sim)
;; given a tick interval, a pixels-per-meter, and the name of an swm file,
;; build a Sim that contains the data from the file
;; - note: the Sim constructed by this function should contain 'None
;;         in the file-chooser slot
;; - note: GIGO applies to this function in all ways
(define (sim-from-file ti ppm filename)
  (local {(define filelines (file->lines filename))
          (define masterhmap (createdictionary filelines #\:))
          (define evnt (build-event masterhmap))
          (define rslts (build-results masterhmap))}
  (initial-sim evnt ti ppm rslts)))


(: set-file-chooser : Sim (Optional FileChooser) -> Sim)
;; given a sim, sets the filechooser for that sim
(define (set-file-chooser sim filechooser)
  (match sim
    [(Sim m e ti ss sc ppm res lbl rk et fc)
     (Sim m e ti ss sc ppm res lbl rk et filechooser)]))


(: build-file-chooser : String String -> FileChooser)
;; given a suffix and a directory name, build a file chooser
;; associating the characters a, b, c, etc. with all the files
;; in the given directory that have the given suffix
;; - note: you don't need to support more than 26 files
;;         (which would exhaust the alphabet) -- consider that
;;         GIGO if it happens
(define (build-file-chooser suf dir)
  (local {(define items (map path->string (directory-list dir)))
          (: char-picker : Integer -> Char)
          ;; gives a letter of the alphabet based on its place in the alphabet
          ;; starting with a=0, b=1,...
          (define (char-picker int)
            (match int
              [0 #\a]
              [1 #\b]
              [2 #\c]
              [3 #\d]
              [4 #\e]
              [5 #\f]
              [6 #\g]
              [7 #\h]
              [8 #\i]
              [9 #\j]
              [10 #\k]
              [11 #\l]
              [12 #\m]
              [13 #\n]
              [14 #\o]
              [15 #\p]
              [16 #\q]
              [17 #\r]
              [18 #\s]
              [19 #\t]
              [20 #\u]
              [21 #\v]
              [22 #\w]
              [23 #\x]
              [24 #\y]
              [25 #\z]))
          (: build-chooser : (Listof String) (Association Char String) Integer
             -> (Association Char String))
          ;; builds an association that chars #\a, #\b etc. to file names
          ;; takes in a list of strings to build the association
          ;; and a holder association that has all of the current items
          ;; thus far that should be in the association for recursive purposes
          ;; Could also have chosen to make recursive function only on the
          ;; Listof KeyValue.
          (define (build-chooser l holder index)
            (match l
              ['() holder]
              [(cons first rest)
               (if (and (string-contains? first suf)
                        (string=? (substring first (- (string-length first)
                                                      (string-length suf)))
                                  suf))
                   (build-chooser rest
                                    (Association
                                     char=?
                                     (append 
                                      (Association-data holder)
                                      (list (KeyValue (char-picker index)
                                                      first))))
                                    (+ 1 index))
                   (build-chooser rest holder index))]))}
  (FileChooser dir (build-chooser items (Association char=? '()) 0))))


(: set-mode : Mode Sim  -> Sim)
;; set the mode in simulation
(define (set-mode mode sim)
  (match sim
    [(Sim m e ti ss sc ppm res lbl rk et fc)
     (Sim mode e ti ss sc ppm res lbl rk et fc)]))


(: set-speed : (U '1x '2x '4x '8x) Sim -> Sim)
;; set the simulation speed
(define (set-speed s sim)
  (match sim
    [(Sim m e ti ss sc ppm res lbl rk et fc)
     (Sim m e ti s sc ppm res lbl rk et fc)]))

         
(: toggle-paused : Sim -> Sim)
;; set 'running sim to 'paused, and set 'paused sim to 'running
;; return any other sim as is
(define (toggle-paused sim)
  (match sim
    [(Sim m e ti ss sc ppm res lbl rk et fc)
     (cond
       [(symbol=? m 'running) (set-mode 'paused sim)]
       [(symbol=? m 'paused) (set-mode 'running sim)]
       [else sim])]))

 
(: reset : Sim -> Sim)
;; reset the simulation to the beginning of the race if the mode is a swimming
;; mode, otherwise keeps mode, i.e. 'choose
(define (reset sim)
  (match sim
    [(Sim m e ti ss sc ppm res lbl rk et fc)
     (cond
       [(symbol=? m 'choose) sim]
       [(symbol=? m 'done)(Sim 'running e ti ss 0 ppm res lbl rk et fc)]
       [else (Sim m e ti ss 0 ppm res lbl rk et fc)])]))


(: react-to-keyboard : Sim String -> Sim)
;; set sim-speed to 1x, 2x, or 4x on "1", "2", "4" in a swimming mode
;; reset the simulation on "r" in a swimming mode
;; chooses the swm file in the chooser screen if possible on 'choose mode
;; d to go back to choose screen in a swimming mode, this refreshes the
;; filechooser
(define (react-to-keyboard sim press)
  (match sim
    [(Sim m e ti ss sc ppm res lbl rk et fc)
     (if (symbol=? m 'choose)
           (local {(define filechooser (Some-value (cast fc(Some FileChooser))))
                   (define input (find-assoc
                                  (string-ref press 0)
                                  (FileChooser-chooser filechooser)))}
             (match input
               ['None sim]
               [x
                (set-file-chooser
                 (sim-from-file ti ppm
                  (string-append (FileChooser-directory filechooser)
                                 "\\"
                                 (Some-value (cast input(Some String))))) fc)]))
           (match press
             ["1" (Sim m e ti '1x sc ppm res lbl rk et fc)]
             ["2" (Sim m e ti '2x sc ppm res lbl rk et fc)]
             ["4" (Sim m e ti '4x sc ppm res lbl rk et fc)]
             ["8" (Sim m e ti '8x sc ppm res lbl rk et fc)]
             ["r" (reset sim)]
             ["d" (Sim 'choose e ti '1x sc ppm res lbl rk et
                       (Some (build-file-chooser
                        ".swm" (FileChooser-directory
                                (Some-value (cast fc (Some FileChooser)))))))]
             [_ sim]))]))


(: react-to-tick : Sim -> Sim)
;; if simulation is 'running, increase sim-clock accordingly
;; - note: the amount of time added to sim-clock depends on sim-speed and
;; tick-rate
(define (react-to-tick sim)
  (match sim
    [(Sim m e ti ss sc ppm res lbl rk et fc)
     (if (symbol=? m 'running)
     (cond
       [(symbol=? ss '1x) (if (<= (+ sc ti) et)
                             (Sim m e ti ss (+ sc ti) ppm res lbl rk et fc)
                             (Sim 'done e ti ss et ppm res lbl rk et fc))]
       [(symbol=? ss '2x) (if (<= (+ sc (* 2 ti)) et)
                             (Sim m e ti ss (+ sc (* 2 ti))ppm res lbl rk et fc)
                             (Sim 'done e ti ss et ppm res lbl rk et fc))]
       [(symbol=? ss '8x) (if (<= (+ sc (* 8 ti)) et)
                             (Sim m e ti ss (+ sc (* 8 ti))ppm res lbl rk et fc)
                             (Sim 'done e ti ss et ppm res lbl rk et fc))]
       [else (if (<= (+ sc (* 4 ti)) et)
                 (Sim m e ti ss (+ sc (* 4 ti)) ppm res lbl rk et fc)
                 (Sim 'done e ti ss et ppm res lbl rk et fc))]) sim)]))


(: react-to-mouse : Sim Integer Integer Mouse-Event -> Sim)
;; pause/unpause the simulation on "button-down" if it is in a swimming mode
(define (react-to-mouse sim x y me)
  (match sim
    [(Sim m e ti ss sc ppm res lbl rk et fc)
     (if (symbol=? m 'choose)
         sim
         (match me
           ["button-down" (toggle-paused sim)]
           [_ sim]))]))


(: text-box-size : Sim String Real (U 'w 'h) -> Real)
;; returns how wide the text should be
;; assumes the size of the text font is some factor times the pixels per meter
(define (text-box-size sim s factor side)
  (match sim
    [(Sim m e tr ss sc ppm po lbl rk et fc)
     (if (symbol=? side 'w)
     (+ (* ppm .1)
      (image-width (text s (cast (exact-floor(* ppm factor)) Byte) 'black)))
     (+ (* ppm .1)
        (image-height (text s(cast(exact-floor(* ppm factor)) Byte)'black))))]))


(: digit : Real Integer -> Integer)
;; returns the digit in the x place of the decimal
;; e.g. (digit 1.213 1) is 2 as 1 is the first digit of the decimal
(define (digit num place)
  (modulo (exact-floor (* num (expt 10 place)))10))


(: mmsshh : Real -> String)
;; display an amount of time in MM:SS.HH format
;; where HH are hundredths of seconds
;; - don't worry about hours, since races are at most
;;   a few minutes long
;; - *do* append a trailing zero as needed
;; ex: (mmsshh 62.23) -> "1:02.23"
;; ex: (mmsshh 62.2)  -> "1:02.20"
(define (mmsshh time)
  (local
    {(define milliseconds (string-append
                           "."
                           (number->string (digit time 1))
                           (number->string (digit time 2))))
     (define seconds (number->string (modulo (exact-floor time) 60)))}
    (if (< time 60)
        (string-append seconds milliseconds)
        (string-append (number->string (exact-floor (/ time 60)))
                       ":"
                       (if (< (modulo (exact-floor time) 60) 10)
                           (string-append "0" seconds)
                           seconds)
                       milliseconds))))

(check-expect (mmsshh 62.23) "1:02.23")
(check-expect (mmsshh 62.2) "1:02.20")
(check-expect (mmsshh 1931.12) "32:11.12")
(check-expect (mmsshh 0.0) "0.00")


(: flag-of : Country -> Image)
;; produce an image of a country's flag
;; - use bitmap/file and find the file include/flags
;; - it is OK to raise an error for a not-found file
(define (flag-of c)
  (local {(define list-of-desired-country
            (filter (lambda ([ s : IOC])(symbol=? (IOC-abbrev s) c))
                                ioc-abbrevs))
          (define cname-unedited (match list-of-desired-country
                          [(cons first rest)(IOC-country first)]))
          (define cname-list (string->list (string-downcase cname-unedited)))
          (define cname (list->string (map (lambda ([ s : Char])
                                             (if (char=? #\space s) #\- s))
                                           cname-list)))}          
  (bitmap/file (string-append "../include/flags/" cname ".png"))))


;; The next 4 functions are from the reference implenetation of project2.
;; Prof Shaw's solution for (current-position) is faster than mine
;; so I've used it instead, although
;; mine works as well, but slower. The other 3 functions are helper functions
;; for his (current-position).
(: elapsed-before : Integer (Listof Real) -> Real)
;; given a list position and a list of splits,
;; compute how much time elapsed before the position
;; ex: (elapsed-before 0 '(1 2 4 8)) -> 0
;; ex: (elapsed-before 1 '(1 2 4 8)) -> 1
;; ex: (elapsed-before 2 '(1 2 4 8)) -> 3
(define (elapsed-before i spl)
  (cond
    [(<= i 0) 0]
    [else
     (match spl
       ['() (error "too few splits in elapsed-before")]
       [(cons hd tl) (+ hd (elapsed-before (sub1 i) tl))])]))


(: opt-map : All (A B) (A -> B) (Optional A) -> (Optional B))
;; apply function to (Some item), do nothing to 'None
(define (opt-map f ox)
  (match ox
    [(Some a) (Some (f a))]
    ['None 'None]))


(: split-index : Real (Listof Real) -> (Optional Integer))
;; find 0-based index of the split the time is "within"
;; (in other words, if the clock is at time t, which lap
;;  is the swimmer currently in?)
;; ex: (split-index 3 '(5 6 7)) -> (Some 0)
;; ex: (split-index 8 '(5 6 7)) -> (Some 1)
;; ex: (split-index 99 '(5 6 7)) -> 'None
(define (split-index t spl)
  (match spl
    ['() 'None]
    [(cons head tail)
     (if (< t head)
         (Some 0)
         (opt-map add1 (split-index (- t head) tail)))]))


(: current-position : Real Result -> Position)
;; compute current position, including direction,
;; at given time
(define (current-position t perf)
  (match perf
    [(Result (Swimmer lname fname c h) spl)
     (match (split-index t spl)
       [(Some i)
        (match* ((list-ref spl i) (elapsed-before i spl))
          [(s e) (cond
                   [(or (odd? i) (= 1 (length spl)))
                    (Position (+ (/ h 2)
                                 (* (/ (- t e) s) (- 50 h)))
                              'east)]
                   [else
                    (Position (- (- 50 (/ h 2))
                                 (* (/ (- t e) s) (- 50 h)))
                              'west)])])]
       ['None (Position (- 50 (/ h 2)) 'finished)])]))

;; below is my implementation of current-position for reference, from project2
;(: current-position : Real Result -> Position)
;;; the arguments to current-position are the current time and a result
;;; - compute the given swimmer's current position, which
;;;   includes a heading 'east or 'west, or 'finished
;(define (current-position time res)
;  (local {(define h (Swimmer-height (Result-swimmer res)))
;          (define splits (Result-splits res))
;          (: pos : Real Real (U 'east 'west) -> Position)
;          ;; gives position of swimmer going from one end of pool
;          ;; to other end of pool akin to a 50-m time
;          (define (pos t one-split dir)
;            (local {(define swimpos (+ (/ h 2) (* (- 50 h) (/ t one-split))))
;                    (define rightend (- 50 (/ h 2)))}
;              (cond
;                [(and (<= swimpos rightend) (symbol=? dir 'east))
;                 (Position swimpos dir)]
;                [(and (> swimpos rightend) (symbol=? dir 'east))
;                 (Position rightend dir)]
;                [(and (<= (/ h 2) swimpos) (symbol=? dir 'west))
;                 (Position (- 50 swimpos) dir)]
;                [else (Position (/ h 2) dir)])))        
;          (: cur-pos : Real (Listof Real) (U 'east 'west)
;             (U 'east 'west) -> Position)
;          ;; recursive function to help compute current position
;          (define (cur-pos time rem-splits dir-cur dir-next)
;            (match rem-splits
;              [(cons first rest)(if (< time first)
;                          (pos time first dir-cur)
;                          (match rest
;                            ['() (if (symbol=? dir-cur 'west)
;                                     (Position (/ h 2) 'finished)
;                                     (Position (- 50 (/ h 2)) 'finished))]
;                            [(cons first2 rest2)
;                             (if (< time (+ first first2))
;                                    (pos (- time first) first2 dir-next)
;                                    (cur-pos time
;                                             (cons (+ first first2) rest2)
;                                             dir-next
;                                             dir-cur))]))]))}
;    (if (= 1 (length splits))
;        (cur-pos time splits 'east 'west)
;        (cur-pos time splits 'west 'east))))

                               
(: quick-sort (All (A) (-> (Listof A) (-> A A Boolean) (Listof A))))
; quick sorts a list using given comparison function
; from Lab 6
(define (quick-sort l comp)
  (match l
    ['() '()]
    [(cons first rest)
     (append
      (quick-sort 
       (filter (lambda ([ a : A]) (comp a first)) rest) comp)
     (list first)
     (quick-sort
      (filter (lambda ([ a : A]) (not (comp a first))) rest) comp))]))


(: initial-sim : Event TickInterval Integer (Listof Result) -> Sim)
;; the parameters are an event, a tick interval, pixels per meter,
;; and a list of results corresponding to a race
;; - this function must precompute the labels, ranks, and end-time
;;   values based on the list of results
(define (initial-sim e ti ppm res)
  (local {(define listofresults
                      (map (lambda ([ r : Result])(Result-splits r)) res))
          (define listoftotaltimes
            (map (lambda ([l : (Listof Real)])(foldr + 0 l))
                 listofresults))
          (define listofswimmers
                      (map (lambda ([ r : Result])(Result-swimmer r)) res))
          (: et : -> Real)
          ;; computes the end-time of a race by taking the max time
          ;; of all the swimmers in the given race
          ;; nlogn time instead of linear due to quicksort
          (define (et)
              (match (quick-sort listoftotaltimes >)
                ['() -1]
                [(cons first rest) first]))
          (: rk : -> (Listof Integer))
          ;; computes the ranks of the swimmers in a given race
          (define (rk)
            (local
              {(: sort-creator1 : (All (A)(Listof A) ->
                  (Listof (Pairof A Integer))))
                 ;; creates list of Pairof with second item in a given Pairof
                 ;; being the integer corresponding to list length minus index
                 (define (sort-creator1 l)
                     (match l
                       ['() '()]
                       [(cons first rest)
                        (append (list
                                 (Pairof first (length l)))
                                (sort-creator1 rest))]))
                 (: comp-int : (Pairof (Pairof Real Integer) Integer)
                    (Pairof (Pairof Real Integer) Integer) -> Boolean)
                 ;; returns true if Integer in the Pairof of the
                 ;; first Pairof is strictly less than Integer in
                 ;; the Pairof of the second Pairof
                 (define (comp-int a b)
                   (< (Pairof-y (Pairof-x a))(Pairof-y (Pairof-x b))))
                 (: comp-real : (Pairof Real Integer)(Pairof Real Integer)
                    -> Boolean)
                 ;; returns true if the Real of the first pairof is strictly
                 ;; less than the read of the second Pairof
                 (define (comp-real a b)
                   (< (Pairof-x a) (Pairof-x b)))           
                 (: samerankfixer : (Listof (Pairof (Pairof Real Integer)
                                                    Integer)) ->
                                       (Listof (Pairof (Pairof Real Integer)
                                                       Integer)))
                 ;; makes two swimmers the same rank if they have the same time
                 (define (samerankfixer l)
                   (match l
                     [(cons first rest)
                      (match* (first rest)
                        [(a '())(list a)]
                        [((Pairof (Pairof t1 x) r1)
                         (cons (Pairof (Pairof t2 y) z) rest2))
                         (if (and (not (= r1 z)) (= t1 t2))
                             (samerankfixer
                              (cons (Pairof (Pairof t2 x) z)
                                    (cons (Pairof (Pairof t2 y) z) rest2)))
                             (cons first (samerankfixer rest)))])]))
                 (define sortedpairoftimes
                   (reverse (quick-sort
                             (sort-creator1 listoftotaltimes)
                             comp-real)))
                 (define sortedlistofranks (sort-creator1 sortedpairoftimes))
                 (define sortedlistofranksproper
                  (samerankfixer sortedlistofranks))
                 (define finalsort
                   (quick-sort sortedlistofranksproper comp-int))}
              (map (lambda
                      ([ p : (Pairof (Pairof Real Integer) Integer)])
                    (Pairof-y p)) finalsort)))
          (: lbl : -> Image)
          ;; creates the name + flags on the right hand side.
          (define (lbl)
            (local
              {(define indimages
                 (map (lambda ([s : Swimmer])
                        (overlay
                         (rectangle (* 2.5 ppm) (* 2.5 ppm)
                                  'solid (color 0 0 0 0))
                         (beside (scale (/ ppm 60)
                                        (flag-of (Swimmer-country s)))
                                 (text  (string-append
                                         (substring (Swimmer-fname s) 0 1)
                                         ". "
                                         (Swimmer-lname s))
                                        (cast (exact-floor (/ ppm 2))
                                              Byte)
                                        'black))))
                      listofswimmers))}
              (foldl (lambda ([i : Image][j : Image])(above/align 'left j i))
                     empty-image indimages)))}
    (Sim 'running e ti '1x 0 ppm res (lbl) (rk) (et) 'None)))


(: rank-image-maker : Sim -> Image)
;; makes the image of the ranks at the end
(define (rank-image-maker sim)
  (match sim
    [(Sim m e tr ss sc ppm po lbl rk et fc)
     (local
       {(define listofrankimages
          (map (lambda ([r : Integer])(overlay
                                       (rectangle (* 2.5 ppm) (* 2.5 ppm)
                                                  'solid (color 0 0 0 0))
                                       (text (number->string r)
                                             (cast (exact-floor (/ ppm 2)) Byte)
                                             'black)
                                       (circle (text-box-size
                                                sim (number->string r) .5 'h)
                                               'outline 'black)
                                       (circle (text-box-size
                                                sim (number->string r) .5 'h)
                                               'solid 'gold))) rk))}
     (above
      (rectangle (* 2.5 ppm) (* 2.5 ppm) 'solid (color 0 0 0 0))
      (foldl above empty-image listofrankimages)
      (rectangle (* 2.5 ppm) (* 2.5 ppm) 'solid (color 0 0 0 0))))]))


(: drawindiv : Sim Real Integer Result -> Image)
;; draws an individual lane, requires the sim clock and pixels per meter
;; also takes in the Sim due to the legacy implementation of (text-box-size)
;; from project1, but I have assumed this does not affect performance too much
(define (drawindiv sim sc ppm res)
  (local
    {(define swmr (Result-swimmer res))
     (define splts (Result-splits res))
     (define height (Swimmer-height swmr))
     (define curpos (current-position sc res))
     (define swmr-img
       (overlay
        (if (symbol=? (Position-direction curpos) 'west)
            (rotate 90 (triangle (* height ppm .2) 'solid 'red))
            (rotate 270 (triangle (* height ppm .2) 'solid 'red)))
        (rectangle (* height ppm)
                   (* ppm .5)
                   'solid
                   'green)))
     (define timetext (mmsshh (foldr + 0 splts)))
     (define timetextwithbox
       (overlay (text timetext
                      (cast (exact-floor (/ ppm 2)) Byte) 'black)
                (rectangle (text-box-size sim timetext .5 'w)
                           (text-box-size sim timetext .5 'h)
                           'outline
                           'black)
                (rectangle (text-box-size sim timetext .5 'w)
                           (text-box-size sim timetext .5 'h)
                           'solid
                           'white)))}
    (cond
      [(symbol=? (Position-direction curpos) 'finished)
       (overlay/align "right" "middle"
                      timetextwithbox
                      (base-lane ppm))]
      [else 
       (place-image
        swmr-img
        (* ppm (Position-x-position (current-position sc res)))
        (* 1.25 ppm)
        (base-lane ppm))])))


(: base-lane : Integer -> Image)
;; draws a single lane based on the pixels per meter
(define (base-lane ppm)
  (overlay
   (rectangle (* 50 ppm)
              (* 2.5 ppm)
              'solid
              (color 0 0
                     255 100))
   (rectangle (* ppm 45) (* ppm .25) 'solid
              (color 100 20 10 30))
   (rectangle (* ppm .25) (* ppm 1.75) 'solid
              (color 100 20 10 30))
   (empty-scene (cast (* 50 ppm) Nonnegative-Real)
                (cast (* 2.5 ppm) Nonnegative-Real))))


(: perfect-sizer : Integer -> (Pairof Integer Integer))
;; this function provides the perfect size of the screen in the initial big
;; bang based on the size of a normal 8 swimmer simulation from project2
;; depends on the pixels per meter
(define (perfect-sizer ppm)
  (local {(define samplerun
            (above/align "left"
                         (beside
                          (foldl above empty-image
                                 (build-list 10 (lambda (x) (base-lane ppm))))
                          (foldl
                           (lambda ([i : Image][j : Image])
                                   (above/align 'left j i))
                           empty-image
                           (build-list
                            10
                            (lambda (x)
                            (overlay
                             (rectangle (* 2.5 ppm) (* 2.5 ppm)'solid "black")
                             (beside (scale (/ ppm 60) (flag-of 'USA))
                                     (text
                                      "a.reallyreallyreallyreallylonglastname"
                                      (cast (exact-floor (/ ppm 2)) Byte)
                                      'black)))))))
                         (text "simulated time (mm:ss.hh : 00:00.00)"
                               (cast (exact-floor (* .8 ppm)) Byte)
                                        'black)
                         (text "simulation running at 8x speed"
                               (cast (exact-floor (* .8 ppm)) Byte)
                                        'black)))}
     (Pairof (image-width samplerun) (image-height samplerun))))


(: draw-an-option : Sim (KeyValue Char String) -> Image)
;; takes a keyvalue and a pixels per meter and draws the image of a single
;; options box
(define (draw-an-option sim kv)
  (local {(define ppm (Sim-pixels-per-meter sim))
          (define key (list->string (list (KeyValue-key kv))))
          (define keywidth (text-box-size sim "a" 1.2 'w))
          (define keyheight (text-box-size sim "a" 1.2 'w))
          (define keyimage
            (overlay
             (text key (cast (exact-floor (* .5 ppm)) Byte) 'blue)
             (rectangle keywidth keyheight 'outline 'black)
             (rectangle keywidth keyheight 'solid 'white)
             (rectangle (* 2 keywidth) keyheight 'solid (color 0 0 0 0))))
          (define file (KeyValue-value kv))
          (define bigrectw
            (* 1.25(+ (image-width keyimage)(text-box-size sim file .5 'w))))
          (define bigrecth (* 2 (image-height keyimage)))}
    (overlay/align "left" "center"
     (rectangle bigrectw (* 1.25 bigrecth) 'solid (color 0 0 0 0))
     (beside keyimage (text file (cast (exact-floor (* .5 ppm)) Byte) 'black))
     (rectangle bigrectw bigrecth 'outline 'black)
     (rectangle bigrectw bigrecth 'solid 'gold))))  
           

(: draw-simulation : Sim -> Image)
;; draw the simulation in its current state,
;; including both graphical and textual elements, if it is in a swimming mode
;; otherwise draws the choose screen
(define (draw-simulation sim)
(match sim
      [(Sim m e ti ss sc ppm res lbl rk et fc)
       (local
         {(define baselane (base-lane ppm))
          (define filechooser (Some-value (cast fc (Some FileChooser))))
          (define informationtime (text (string-append
                                         "simulated time (mm:ss.hh): "
                                         (mmsshh sc))
                                        (cast (exact-floor (* .8 ppm)) Byte)
                                        'black))
          (define informationspeed (text (string-append
                                          "simulation running at "
                                          (symbol->string ss)
                                          " speed")
                                         (cast (exact-floor (* .8 ppm)) Byte)
                                         'black))
          (define coreimage
            (above/align "left"
                         (beside
                          (above
                           baselane
                           (foldl (lambda ([ r : Result][i : Image])
                                    (above i (drawindiv sim sc ppm r)))
                                  empty-image res)
                           baselane)
                          lbl)
                         informationtime))
          (define coreimagedone                   
            (above
             baselane
             (foldl (lambda ([ r : Result][i : Image])
                      (above i (drawindiv sim sc ppm r))) empty-image res)
             baselane))
          (define coreimagerunning
            (above/align "left" coreimage informationspeed))}
         (cond
           [(symbol=? m 'choose)
            (local {(define overallsize (perfect-sizer ppm))}
            (overlay/align "left" "top"
             (above (text
                     (string-append "current directory: "
                                    (FileChooser-directory filechooser))
                    (cast (exact-floor (* .5 ppm)) Byte)
                                         'black)
                    (foldl (lambda ([keyv : (KeyValue Char String)][i : Image])
                             (above/align "left" i (draw-an-option sim keyv)))
                           empty-image
                           (Association-data(FileChooser-chooser filechooser))))
             (rectangle (Pairof-x overallsize)(Pairof-y overallsize)
                      "solid" "white")))]
           [(symbol=? m 'running) coreimagerunning]
           [(symbol=? m 'paused)
            (above/align
             "left" 
             (overlay/align "right" "bottom"
                            (overlay
                             (text "PAUSED" (cast (exact-floor (* .8 ppm))Byte)
                                   'black)
                             (rectangle (text-box-size sim "PAUSED" .8 'w)
                                        (text-box-size sim "PAUSED" .8 'h)
                                        'outline
                                        'black)
                             (rectangle (text-box-size sim "PAUSED" .8 'w)
                                        (text-box-size sim "PAUSED" .8 'h)
                                        'solid
                                        'yellow))
                            coreimage)
             informationspeed)]
           [else
            (above/align "left"
                         (beside
                          (overlay
                           (rank-image-maker sim)
                           coreimagedone)
                          lbl)
                         informationtime)]))]))


(: month-to-text : Date -> String)
;; returns the month in the Date
(define (month-to-text d)
  (match d
    [(Date 1 _ _) "January"]
    [(Date 2 _ _) "February"]
    [(Date 3 _ _) "March"]
    [(Date 4 _ _) "April"]
    [(Date 5 _ _) "May"]
    [(Date 6 _ _) "June"]
    [(Date 7 _ _) "July"]
    [(Date 8 _ _) "August"]
    [(Date 9 _ _) "September"]
    [(Date 10 _ _) "October"]
    [(Date 11 _ _) "November"]
    [(Date 12 _ _) "December"]))


(: run : TickInterval Integer String -> Sim)
;; the parameters are a tick interval, pixels per meter,
;; and a string with a directory of .swm files.
;; runs the simulation with given starting arguments, starting at the choose
;; screen
(define (run ti ppm dir)
  (big-bang (Sim 'choose
                  (Event 'Women 50 'Freestyle "" (Date 1 1 1))
                  ti
                  '1x
                  0
                  ppm
                  '()
                  empty-image
                  '()
                  0
                  (Some (build-file-chooser ".swm" dir))) : Sim
    [name "Andrew's Olympic Swimming Simulation"]
    [to-draw draw-simulation]
    [on-mouse react-to-mouse]
    [on-key react-to-keyboard]
    [on-tick react-to-tick ti]))


(test)