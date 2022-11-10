\begin{code}

open import MLTT.Spartan
open import UF.Base
open import UF.PropTrunc
open import UF.FunExt
open import UF.Univalence
open import UF.UA-FunExt

module UniformContinuityTopos.UniformContinuityCoverage
        (pt : propositional-truncations-exist)
        (fe : Fun-Ext)
        where

open import UF.Subsingletons
open import UF.Subsingleton-Combinators

open AllCombinators pt fe

open import UniformContinuityTopos.UniformContinuityMonoid pt fe
open import UniformContinuityTopos.MonoidAction fe
open import UniformContinuityTopos.Vector

open import UniformContinuityTopos.Coverage pt fe ℂ

open PropositionalTruncation pt

\end{code}

\begin{code}

private
 variable
  n : ℕ

cons-bit : 𝟚 → Cantor → Cantor
cons-bit b α zero     = b
cons-bit b α (succ i) = α i

cons : Vec 𝟚 n → Cantor → Cantor
cons []      = id
cons (b ∷ b⃗) = cons-bit b ∘ cons b⃗

cons-bit-is-uniformly-continuous : (b : 𝟚)
                                 → is-uniformly-continuous (cons-bit b) holds
cons-bit-is-uniformly-continuous b zero     = ∣ zero , (λ _ _ _ → ⋆) ∣
cons-bit-is-uniformly-continuous b (succ m) = ∣ m    , φ             ∣
 where
  φ : (α β : Cantor)
    → (α ＝⟦ m ⟧ β ⇒ cons-bit b α ＝⟦ succ m ⟧ cons-bit b β) holds
  φ α β p = refl , p

cons-uniformly-continuous : (b⃗ : Vec 𝟚 n) → is-uniformly-continuous (cons b⃗) holds
cons-uniformly-continuous []      = id-is-uniformly-continuous
cons-uniformly-continuous (b ∷ b⃗) =
 ∘-is-uniformly-continuous (cons b⃗) (cons-bit b) ℐℋ †
  where
   ℐℋ : is-uniformly-continuous (cons b⃗) holds
   ℐℋ = cons-uniformly-continuous b⃗

   † : is-uniformly-continuous (cons-bit b) holds
   † = cons-bit-is-uniformly-continuous b

𝔠𝔬𝔫𝔰 : Vec 𝟚 n → UC-Endomap
𝔠𝔬𝔫𝔰 b⃗ = cons b⃗ , cons-uniformly-continuous b⃗

𝒥 : Fam 𝓤₀ (Fam 𝓤₀ ⟪ ℂ ⟫)
𝒥 = ℕ , (λ n → Vec 𝟚 n , 𝔠𝔬𝔫𝔰)

open EqualityCombinator ⟪ ℂ ⟫ (monoid-carrier-is-set ℂ)

𝒥-is-coverage : is-coverage 𝒥 holds
𝒥-is-coverage = †
 where
  Ψ : Ω 𝓤₀
  Ψ = Ɐ t ∶ ⟪ ℂ ⟫ , Ɐ m ∶ ℕ ,
       Ǝ̃ n ∶ ℕ ,
        Ɐ s ∶ Vec 𝟚 n ,
         Ǝ̃ t′ ∶ ⟪ ℂ ⟫ , Ǝ̃ s′ ∶ Vec 𝟚 m ,
          t ⊚ 𝔠𝔬𝔫𝔰 s ＝ₛ 𝔠𝔬𝔫𝔰 s′ ⊚ t′

  † : Ψ holds
  † t m = {!!}

\end{code}
