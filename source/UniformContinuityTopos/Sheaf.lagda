\begin{code}


open import MLTT.Spartan
open import UF.Base
open import UF.PropTrunc
open import UF.FunExt
open import UF.Univalence
open import UF.Miscelanea
open import UF.UA-FunExt
open import MLTT.Fin

open import UF.SIP-Examples
open monoid

module UniformContinuityTopos.Sheaf
        (pt  : propositional-truncations-exist)
        (fe  : Fun-Ext)
        where

open import UF.Subsingletons
open import UF.Subsingleton-Combinators

open AllCombinators pt fe

open import UniformContinuityTopos.Vector
open import UniformContinuityTopos.MonoidAction fe
open import UniformContinuityTopos.UniformContinuityMonoid pt fe
open import UniformContinuityTopos.UniformContinuityCoverage pt fe
open import UF.Subsingletons-FunExt
open import UF.Retracts

open PropositionalTruncation pt

\end{code}

\begin{code}

is-sheaf : [ ℂ ]-set 𝓥 → Ω 𝓥
is-sheaf ((P , s) , _·_ , ν) =
 Ɐ n ∶ ℕ , Ɐ 𝓅 ∶ (Vec 𝟚 n → P) ,
  !∃ p ∶ P ,
   Ɐ s ∶ Vec 𝟚 n , p · 𝔠𝔬𝔫𝔰 s ＝ₛ 𝓅 s
    where
     open EqualityCombinator P s

Sheaf : (𝓤 : Universe) → 𝓤 ⁺  ̇
Sheaf 𝓤 = Σ 𝒫 ꞉ [ ℂ ]-set 𝓤 , is-sheaf 𝒫 holds

∣_∣ₚ : [ ℂ ]-set 𝓤 → 𝓤  ̇
∣ 𝒫 ∣ₚ = pr₁ (pr₁ 𝒫)

∣_∣ₛ : Sheaf 𝓤 → 𝓤  ̇
∣ 𝒫 ∣ₛ = pr₁ (pr₁ (pr₁ 𝒫))

\end{code}

\begin{code}

is-natural : (𝒫 𝒬 : [ ℂ ]-set 𝓤) → (∣ 𝒫 ∣ₚ → ∣ 𝒬 ∣ₚ) → Ω 𝓤
is-natural ((P , _) , (_·₁_ , _)) ((Q , σ₂) , (_·₂_ , _)) ϕ =
 Ɐ p ∶ P , Ɐ u ∶ ⟪ ℂ ⟫ , ϕ (p ·₁ u) ＝ₛ (ϕ p) ·₂ u
  where
   open EqualityCombinator Q σ₂ using (_＝ₛ_)

is-natural′ : (𝒫 𝒬 : Sheaf 𝓤) → (∣ 𝒫 ∣ₛ → ∣ 𝒬 ∣ₛ) → Ω 𝓤
is-natural′ (𝒫 , _) (𝒬 , _) = is-natural 𝒫 𝒬

ℋℴ𝓂 : Sheaf 𝓤 → Sheaf 𝓤 → 𝓤  ̇
ℋℴ𝓂 (𝒫@((P , _) , _) , _) (𝒬@((Q , _) , _) , _) =
 Σ ϕ ꞉ (P → Q) , is-natural 𝒫 𝒬 ϕ holds

apply : (𝒫 𝒬 : Sheaf 𝓤) → ℋℴ𝓂 𝒫 𝒬 → ∣ 𝒫 ∣ₛ → ∣ 𝒬 ∣ₛ
apply 𝒫 𝒬 (𝒻 , _) = 𝒻

underlying-presheaf : Sheaf 𝓤 → [ ℂ ]-set 𝓤
underlying-presheaf (P , _) = P

sheaf-is-set : (𝒫 : Sheaf 𝓤) → is-set ∣ 𝒫 ∣ₛ
sheaf-is-set (((P , σ) , _) , _) = σ

ℋℴ𝓂-is-set : (𝒫 𝒬 : Sheaf 𝓤) → is-set (ℋℴ𝓂 𝒫 𝒬)
ℋℴ𝓂-is-set 𝒫 𝒬 =
 Σ-is-set
  (Π-is-set fe λ _ → sheaf-is-set 𝒬)
  λ f → props-are-sets (holds-is-prop (is-natural′ 𝒫 𝒬 f))

ℋℴ𝓂ₛ : Sheaf 𝓤 → Sheaf 𝓤 → hSet 𝓤
ℋℴ𝓂ₛ 𝒫 𝒬 = ℋℴ𝓂 𝒫 𝒬 , ℋℴ𝓂-is-set 𝒫 𝒬

\end{code}

The identity natural transformation:

\begin{code}

𝟏[_] : (P : Sheaf 𝓤) → ℋℴ𝓂 P P
𝟏[ P ] = id , λ _ _ → refl

\end{code}

Composition of natural transformations:

\begin{code}

∘-is-natural : (𝒫 𝒬 ℛ : Sheaf 𝓤) (ϕ : ∣ 𝒫 ∣ₛ → ∣ 𝒬 ∣ₛ) (ψ : ∣ 𝒬 ∣ₛ → ∣ ℛ ∣ₛ)
             → is-natural′ 𝒫 𝒬 ϕ holds
             → is-natural′ 𝒬 ℛ ψ holds
             → is-natural′ 𝒫 ℛ (ψ ∘ ϕ) holds
∘-is-natural 𝒫 𝒬 ℛ ϕ ψ β γ p u = ψ (ϕ (p ·₁ u))     ＝⟨ ap ψ (β p u) ⟩
                                 ψ (ϕ p ·₂ u)       ＝⟨ γ (ϕ p) u    ⟩
                                 ψ (ϕ p) ·₃ u       ∎
  where
   _·₁_ = μ ℂ (underlying-presheaf 𝒫)
   _·₂_ = μ ℂ (underlying-presheaf 𝒬)
   _·₃_ = μ ℂ (underlying-presheaf ℛ)

comp : (𝒫 𝒬 ℛ : Sheaf 𝓤) → ℋℴ𝓂 𝒬 ℛ → ℋℴ𝓂 𝒫 𝒬 → ℋℴ𝓂 𝒫 ℛ
comp 𝒫 𝒬 ℛ (ψ , ν₂) (ϕ , ν₁) = (ψ ∘ ϕ) , χ
 where
  χ : is-natural′ 𝒫 ℛ (ψ ∘ ϕ) holds
  χ = ∘-is-natural 𝒫 𝒬 ℛ ϕ ψ ν₁ ν₂

\end{code}

The terminal sheaf

\begin{code}

𝟏ₛ : Sheaf 𝓤
𝟏ₛ = ((𝟙 , 𝟙-is-set) , _·_ , γ) , ♠
 where
  open EqualityCombinator 𝟙 𝟙-is-set

  _·_ : 𝟙 → ⟪ ℂ ⟫ → 𝟙
  ⋆ · _ = ⋆

  γ : is-[ ℂ ]-action 𝟙-is-set _·_ holds
  γ = 𝟙-is-prop ⋆ , λ { ⋆ x y → refl }

  ♠ : is-sheaf ((𝟙 , 𝟙-is-set) , _·_ , γ) holds
  ♠ i f = (⋆ , †) , λ { (⋆ , p) → to-subtype-＝ (λ { ⋆ → holds-is-prop ((Ɐ s ∶ Vec 𝟚 i , ⋆ ＝ₛ ⋆)) }) refl }
   where
    † : (Ɐ s ∶ Vec 𝟚 i , ⋆ ＝ₛ ⋆) holds
    † _ = refl

\end{code}

\begin{code}

 -- self-action-is-sheaf : is-sheaf (self-action M) holds
 -- self-action-is-sheaf i 𝒿 = (ε[ M ] , †) , {!!}
 --  where
 --   † : (j : index (𝒥 [ i ])) → ε[ M ] *[ M ] (𝒥 [ i ] [ j ]) ＝ 𝒿 j
 --   † j = {!!}

\end{code}
