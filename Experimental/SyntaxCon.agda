module SyntaxCon where

open import Relation.Binary.PropositionalEquality

{- Definition of a syntax for weak ω-categories (incomplete) -}

mutual

  {- Context record the existence of objects in some definable category -}
  data Con : Set where
    ε : Con
    _,_ : (Γ : Con)(C : Cat Γ) → Con

  {- A category is either the base category or the hom category of a previosuly constructed category -}
  data Cat : (Γ : Con) → Set where
    • : ∀ {Γ} → Cat Γ 
    hom : ∀ {Γ} → HomSpec Γ → Cat Γ
--    wk : ∀ {Γ} → (C : Cat Γ) → ∀ {D} → Cat (Γ , D)
    wkCat : ∀ {Γ} → (C : Cat Γ) → ∀ D → Cat (Γ , D)
    {- wk should be defined recursively, otherwise we have equivalent expressions. -}

  _,'_ : (Γ : Con)(C : Cat Γ) → Con
  _,'_ = _,_

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

  data Var : {Γ : Con}(C : Cat Γ) → Set where
<<<<<<< HEAD
    vz : ∀ {Γ}{C : Cat Γ} → Var {Γ , C} (wkCat C {C})
    vs : ∀ {Γ}{C D : Cat Γ} → Var {Γ} C → Var {Γ , D} (wkCat C {D})
=======
    vz : ∀ {Γ}{C : Cat Γ} → Var {Γ , C} (wkCat' C C)
    vs : ∀ {Γ}{C : Cat Γ} → Var {Γ} C → (D : Cat Γ) → Var {Γ , D} (wkCat' C D)
>>>>>>> b137a18efef7a6209351eec7285cd0006e473660

  data Obj : {Γ : Con}(C : Cat Γ) → Set where 
    var : ∀ {Γ}{C : Cat Γ} → Var C → Obj C
    id : ∀ {Γ}{C : Cat Γ }(A : Obj C) → Obj (hom (C [ A , A ]))
    comp : ∀ {Γ}{C : Cat Γ}(Δ : Comp C) → Hom (compSrc₀ Δ) → Hom (compSrc₁ Δ) → Obj (hom (compTgt Δ))

  {- Little hack needed because of Agda's current implementation of mutual. -}
  comp' : ∀ {Γ}{C : Cat Γ}(Δ : Comp C) → Hom (compSrc₀ Δ) → Hom (compSrc₁ Δ) → Hom (compTgt Δ)
  comp' = comp

<<<<<<< HEAD
  {- weakening boilerplate... -}

  wkCat :  ∀ {Γ} → (C : Cat Γ) → ∀ {D} → Cat (Γ ,' D)
  wkCat • = •
  wkCat (hom (C [ A , B ])) = hom ((wkCat C) [ {!!} , {!!} ])

{-
  wkObj : {Γ : Con}{C D : Cat Γ} → Obj C → Obj (wkCat C )
  wkObj A = {!!}
=======
  wkCat' :  ∀ {Γ} → (C : Cat Γ) → ∀ D → Cat (Γ ,' D)
  wkCat' = wkCat

{-
  {- weakening boilerplate... -}

  wkCat :  ∀ {Γ} → (C : Cat Γ) → ∀ D → Cat (Γ ,' D)
  wkCat • D = •
  wkCat (hom Cab) D = hom (wkHomSpec Cab D)

  wkHomSpec : ∀ {Γ} → HomSpec Γ → ∀ D → HomSpec (Γ ,' D)
  wkHomSpec (C [ A , B ]) D = ((wkCat C D) [ wkObj A D , wkObj B D ])

  wkObj : {Γ : Con}{C : Cat Γ} → Obj C → (D : Cat Γ) → Obj (wkCat C D)
  wkObj (var x) D = var (vs x D)
  wkObj (id A) D = id (wkObj A D)
  wkObj (comp Δ f g) D = 
    subst (λ x → Obj x) {!!} (comp (wkComp Δ D) {!!} {!!})
  -- Obj (wkCat (hom (compTgt Δ)) D)
  {- termination checker doesn't like subst, hence we need to close all
     wkops under equality. -}

  wkComp : {Γ : Con}{C : Cat Γ} → Comp C → (D : Cat Γ) → Comp (wkCat C D)
  wkComp (obj→ a b c) D = obj→ (wkObj a D) (wkObj b D) (wkObj c D)
  wkComp (hom→ Δ f f' g g') D = hom→ (wkComp Δ D) {!!} {!!} {!!} {!!}

  wkCompTgt : {Γ : Con}{C : Cat Γ}(Δ : Comp C)(D : Cat Γ)
    → compTgt (wkComp Δ D) ≡ wkHomSpec (compTgt Δ) D
  wkCompTgt Δ D = {!!}

{-
  wkCompSrc₀ : {Γ : Con}{C : Cat Γ}(Δ : Comp C)(D : Cat Γ)
    → wkObj (compSrc₀ Δ) D ≡ compSrc₀ (wkComp Δ D)
  wkCompSrc₀ Δ D = ?
-}

>>>>>>> b137a18efef7a6209351eec7285cd0006e473660
-}