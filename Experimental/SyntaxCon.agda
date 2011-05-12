module SyntaxCon where
{- Definition of a syntax for weak ω-categories (incomplete) -}

mutual

  {- Context record the existence of objects in some definable category -}
  data Con : Set where
    ε : Con
    _,_ : (Γ : Con)(C : Cat Γ) → Con

  {- A category is either the base category or the hom category of a previosuly constructed category -}
  data Cat (Γ : Con) : Set where
    • : Cat Γ 
    hom : HomSpec Γ → Cat Γ

  {- A HomSpec specifies a homset by a category and two objects -}
  record HomSpec (Γ : Con) : Set where
    constructor _[_,_]
    field 
      cat : Cat Γ
      src dom : Obj cat

  {- Homsets are given by hom objects -}
  Hom : ∀ {Γ} → HomSpec Γ → Set
  Hom Cab = Obj (hom Cab)

  {- Comp records the data for all possible compositions. -}
  data Comp {Γ}(C : Cat Γ) : Set where
    {- vertical composition -}
    obj→ : (a b c : Obj C) → Comp C
    {- horizontal compositions (there are infinitely many of them). -}
    hom→ : (Δ : Comp C)(f f' : Hom (compSrc₀ Δ))(g g' : Hom (compSrc₁ Δ))  → Comp C

  {- Calculates the HomSpec of the 1st argument of comp -}
  compSrc₀ : ∀ {Γ}{C : Cat Γ} → (Δ : Comp C) → HomSpec Γ
  compSrc₀ {C = C} (obj→ a b c) = C [ b , c ]
  compSrc₀ (hom→ Δ f f' g g') = (hom (compSrc₀ Δ)) [ f , f' ]
  
  {- Calculates the HomSpec of the 2nd argument of comp -}
  compSrc₁ : ∀ {Γ}{C : Cat Γ} → (Δ : Comp C) → HomSpec Γ
  compSrc₁ {C = C} (obj→ a b c) = C [ a , b ]
  compSrc₁ (hom→ Δ f f' g g') = (hom (compSrc₁ Δ)) [ g , g' ]

  {- Calculates the HomSpec of the result of Comp. -} 
  compTgt : ∀ {Γ}{C : Cat Γ} → (Δ : Comp C) → HomSpec Γ
  compTgt {C = C} (obj→ a b c) = C [ a , c ]
  compTgt (hom→ Δ f f' g g') = (hom (compTgt Δ)) [ comp' Δ f g , comp' Δ f' g' ]

  {- Maybe this could be done a bit more abstractly for any functor whose range is a homset.-}

  {- We define object expressions, in the moment only id and comp
     should add lots of morphisms recording equations and coherence. -}

  data Obj : {Γ : Con}(C : Cat Γ) → Set where 
    id : ∀ {Γ}{C : Cat Γ }(a : Obj C) → Obj (hom (C [ a , a ]))
    comp : ∀ {Γ}{C : Cat Γ}(Δ : Comp C) → Hom (compSrc₀ Δ) → Hom (compSrc₁ Δ) → Obj (hom (compTgt Δ))

  {- Little hack needed because of Agda's current implementation of mutual. -}
  comp' : ∀ {Γ}{C : Cat Γ}(Δ : Comp C) → Hom (compSrc₀ Δ) → Hom (compSrc₁ Δ) → Hom (compTgt Δ)
  comp' = comp
