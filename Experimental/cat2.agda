module Cat2 where

open import Relation.Binary.PropositionalEquality
--open import Data.Nat
--open import Data.Vec
open import Data.Product
open import Data.Unit


record Cat₁ : Set₁ where
  field
    obj : Set
    hom : obj → obj → Set
    id : ∀ {a} → hom a a
    comp : ∀ {a b c} → hom b c → hom a b → hom a c
    lid : ∀ {a b} (f : hom a b) → comp id f ≡ f
    rid : ∀ {a b} (f : hom a b) → comp f id ≡ f
    assoc : ∀ {a b c d} (f : hom a b)(g : hom b c)(h : hom c d)
            → comp (comp h g) f ≡ comp h (comp g f)
  record Iso (a b : obj) : Set where
    field 
      a→b : hom a b
      b→a : hom b a
      a→a : comp b→a a→b ≡ id
      b→b : comp a→b b→a ≡ id

record Func₁ (A B : Cat₁) : Set where
  open Cat₁
  field
    obj→ : obj A → obj B
    hom→ : ∀ {a b} → hom A a b
                  → hom B (obj→ a) (obj→ b)
    id→ : ∀ {a} → hom→ (id A {a}) ≡ id B {obj→ a} 
    comp→ :  ∀ {a b c}{f : hom A b c}{g : hom A a b}
                  → hom→ (comp A f g) ≡ comp B (hom→ f) (hom→ g)

record Eq {A B : Cat₁}(F G : Func₁ A B) : Set where
  open Cat₁
  open Func₁
  open Iso
  field
    obj≡ : {a : obj A} → Iso B (obj→ F a) (obj→ G a)
    hom≡ : {a a' : obj A}{f : hom A a a'}
           → comp B (hom→ G f) (a→b B (obj≡ {a})) ≡ comp B (a→b B (obj≡ {a'})) (hom→ F f)

⊤C : Cat₁
⊤C = record {
       obj = ⊤;
       hom = λ _ _ → ⊤;
       id = λ {_} → _;
       comp = λ _ _ → _;
       lid = λ f → refl;
       rid = λ f → refl;
       assoc = λ f g h → refl }


infix 4 _×C_
_×C_ : Cat₁ → Cat₁ → Cat₁
C ×C D = record {
           obj = obj C × obj D ;
           hom = λ cd cd' → hom C (proj₁ cd) (proj₁ cd') × hom D (proj₂ cd) (proj₂ cd') ;
           id = λ {cd} → (id C {proj₁ cd}) , ((id D {proj₂ cd})) ;
           comp = λ ff gg → comp C (proj₁ ff) (proj₁ gg) , comp D (proj₂ ff) (proj₂ gg) ;
           lid = λ ff → cong₂ _,_ (lid C (proj₁ ff)) ((lid D (proj₂ ff))) ;
           rid = λ ff → cong₂ _,_ (rid C (proj₁ ff)) ((rid D (proj₂ ff))) ;
           assoc = λ f g h → cong₂ _,_ (assoc C (proj₁ f) (proj₁ g) (proj₁ h))
                                      ((assoc D (proj₂ f) (proj₂ g) (proj₂ h))) }
         where open Cat₁

record Cat₂ : Set₁ where
  field
    obj : Set
    hom : obj → obj → Cat₁
    id : ∀ {a} → Func₁ ⊤C (hom a a)
    comp : ∀ {a b c} → Func₁ (hom b c ×C hom a b) (hom a c)
{-
    lid : ∀ {a b} (f : hom a b) → comp id f ≡ f
    rid : ∀ {a b} (f : hom a b) → comp f id ≡ f
    assoc : ∀ {a b c d} (f : hom a b)(g : hom b c)(h : hom c d)
            → comp (comp h g) f ≡ comp h (comp g f)
-}