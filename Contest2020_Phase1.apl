⍝ Problem 1
{(⌽⍣(⍺<0))(⍺↑⍵)(⍺↓⍵)}

⍝ Problem 2
(128∘≤⍲≤∘191)⊂⊢

⍝ Problem 3
26⊥⎕A⍳⊢

⍝ Problem 4
{2 0∊⍨+⌿0<4 100 400∘.|⍵}

⍝ Problem 5
{(⊃⍵)+0,(×d)×⍳|d←--/⍵}

⍝ Problem 6
{(⍵~t),t←⍵~⍺}

⍝ Problem 7
{f←⌽(2∘⊥⍣¯1)⋄A≡A∧(≢A←f⍺)↑f⍵}

⍝ Problem 8
{(∧/2≠/b)∧(2</z)≡~b←2>/z←(10∘⊥⍣¯1)⍵}

⍝ Problem 9
{m←(,⍵)⍳⌈/⍵ ⋄ ∧/(⍳∘≢≡⍋)¨(m↑⍵)(⌽m↓⍵)}

⍝ Problem 10
{⍕↑⊃,/↓∘⍕¨⍵}

⍝ POST-CONTEST NOTES:
⍝ Leading ⍕ is unnecessary in task 10 (due to Dimitri Lozeve).
⍝ A nicer solution for Problem 8: {×/0>2×/2-/10(⊥⍣¯1)⍵}
⍝   Source: https://github.com/rak1507/APL-Competition-2020
