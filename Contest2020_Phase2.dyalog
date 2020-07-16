:Namespace Contest2020
⍝ === VARIABLES ===

L←⎕av[3+⎕io]
AboutMe←L,''

FilePath←'/tmp/'

_←⍬
_,←L,''
Reaction←_

⎕ex¨ 'L' '_'

⍝ === End of variables definition ===

(⎕IO ⎕ML ⎕WX ⎕PP)←1 1 3 9

:Namespace Problems
(⎕IO ⎕ML ⎕WX ⎕PP)←1 1 3 9

 Balance←{
          ⍝ 2020 APL Problem Solving Competition Phase II
          ⍝ Problem 8, Task 1 - Balance
     
          ⍝ First, I find the half of the total sum.
          ⍝ Return ⍬ if it's odd (cannot be split evenly).
     half≠⌊half←2÷⍨+/⍵:⍬
     
          ⍝ Next there are two solutions with different time complexities.
     
          ⍝ Solution A: Dynamic programming. Time complexity: O(half×≢nums)
          ⍝ It works faster for small total sum or relatively many numbers.
     th←550÷2*(0⌈20-≢⍵)     ⍝ empiric threshold for when A works faster than B
     half<th:BalanceDynamic ⍵
     
          ⍝ Solution B: Matrix multiplication. Time complexity: O((≢nums)×2*(≢nums))
          ⍝ This solution finds all possible solutions at once.
          ⍝ Steps:
          ⍝ 1) Assume that the first number will go to the second part.
          ⍝    This breaks symmetry and reduces the search space by half.
          ⍝ 2) Consider all possible combinations for the remaining numbers.
          ⍝    For this, generate matrix of all boolean vectors of size (¯1+≢⍵).
          ⍝ 3) Multiply this matrix by nums to get the sums of each possible subset.
          ⍝ 4) See if there is a subset which sums to the half of the total sum.
          ⍝ 5) If there is no such subset then return ⍬.
          ⍝ 6) Otherwise split the numbers into two groups and return them.
          ⍝    One group represents the found subset and another – the other half of
          ⍝    the total sum.
     
     sz←¯1+≢⍵                               ⍝ vector size (≤19)
     bin←(sz⍴2)⊤⊢                           ⍝ function to convert to binary vec
     sol←((1↓⍵)+.×(bin ¯1+⍳2*sz))⍳half      ⍝ find a solution
     sol>2*sz:⍬                             ⍝ return ⍬ if there is no solution
     mask←0,bin ¯1+sol                      ⍝ prepare a mask for the solution
     (mask/⍵)((~mask)/⍵)                    ⍝ split nums according to mask
 }

 BalanceDynamic←{
          ⍝ Dynamic programming solution of the balance weights problem.
          ⍝ Works faster than matrix multiplication approach for small total sums.
     
          ⍝ Find the half of the total sum (again).
          ⍝ Return ⍬ if it's odd (cannot be split evenly).
     half≠⌊half←2÷⍨+/⍵:⍬
     
          ⍝ Initialize matrix which shows if a given sum can
          ⍝ be constructed using a subset of first few numbers.
          ⍝ First index is sum + 1.
          ⍝ Second index is the number of first nums considered + 1.
     M←(1(1+≢⍵))⍴1      ⍝ zero sum is always possible
     
          ⍝ Calculate the array values row by row:
          ⍝ for each sum from 1 to half consider ≢nums subsets.
          ⍝ Outer dnf takes nums on the left, sum on the right.
          ⍝ Inner dnf takes  sum on the left, a subset of nums on the right.
          ⍝ Scan operator with logical OR ∨\ is used to propagate a solution to the
          ⍝ right. Because a solution for a subset also works for bigger subsets.
     ign←(⊂⍵){
         ⊢M⍪←(0,∨\⍵{⍺≤⊃⌽⍵:0 ⋄ M[⍺-⊃⌽⍵;≢⍵]}¨,\⍺)
     }¨1+⍳half
     
          ⍝ If the sum `half` cannot be constructed return ⍬
     ~M[1+half;1+≢⍵]:⍬
     
          ⍝ Extract a concrete solution from the matrix by
          ⍝ backtracking from the target sum to zero recursively.
     mask←(half+1){
         0=≢⍵:⍬
         M[⍺;≢⍵]∨⍺=1:(⍺ ∇ ¯1↓⍵),0
         ((⍺-⊃¯1↑⍵)∇ ¯1↓⍵),1
     }⍵
     (mask/⍵)((~mask)/⍵)
 }

 CheckDigit←{
          ⍝ 2020 APL Problem Solving Competition Phase II
          ⍝ Problem 7, Tasl 1 - CheckDigit
     
          ⍝ Derived from check digit definition:
          ⍝ 1) Multiply the first 11 digits by (3, 1, ..., 3) elementwise
          ⍝ 2) Find the sum and negate it
          ⍝ 3) Find the residue modulus 10 – this is the check digit
     
     10|-+/(11⍴3 1)×11↑⍵
 }

 DiveScore←{
          ⍝ 2020 APL Problem Solving Competition Phase II
          ⍝ Problem 1, Task 1 - DiveScore
     
          ⍝ Straightforward calculation:
          ⍝ 1) Obtain the sorting permutation vector with grade up
          ⍝ 2) Drop the indices for the lowest outliers and take the middle three indices
          ⍝ 3) Sum the scores for the remaining indices
          ⍝ 4) Multiply by difficulty
     
     ⍺×+/⍵[3↑(2÷⍨¯3+≢⍵)↓⍋⍵]
 }

 Merge←{
          ⍝ 2020 APL Problem Solving Competition Phase II
          ⍝ Problem 6, Task 1 - Merge
     
          ⍝ 1) Load and parse the JSON file into a namespace
          ⍝ 2) Load the names of the values into a vector
     ns←⎕JSON⊃⎕NGET ⍵
     names←ns.⎕NL ¯2
     
          ⍝ 1) Load the template file and find all the ats (@).
          ⍝ 2) Find a partitioning of text based on positions of ats.
          ⍝ 3) Modify the partitioning to place all ats into one partition.
          ⍝    This is achieved by decrementing values at every other at.
     parts←1++\ats←'@'=template←⊃⎕NGET ⍺
     parts[⍸(≠parts)∧ats∧(2|parts)]-←1
     
          ⍝ A helper function to process partitions
     replace←{
              ⍝ 1) Return parameter without changes if it's not a merge area.
              ⍝ 2) Obtain the name of the merge area.
              ⍝ 3) Special case: if the name is empty it means at(@) character.
              ⍝ 4) Look for the merge area name in the namespace.
              ⍝ 5) Return "???" if not found.
     
         ('@'≢⊃¯1↑⍵)∨(1≥≢⍵)∨'@'≢⊃⍵:⍵
         name←¯1↓1↓⍵
         0=≢name:'@'
         (⊂name)∊names:⍕ns⍎name
         '???'
     }
     
          ⍝ 1) Partition the template.
          ⍝ 2) Replace all the merge areas.
          ⍝ 3) Concatenate the resulting strings.
     ,/replace¨(parts⊆template)
 }

 PastTasks←{
          ⍝ 2020 APL Problem Solving Competition Phase II
          ⍝ Problem 3, Task 1 - PastTasks
     
          ⍝ GET the web page via HTTP
     res←HttpCommand.Get ⍵
     
          ⍝ Parse XML
     parsed←⎕XML res.Data
     
          ⍝ Find all <A> tags and obtain their attributes
     attrs←⊃⍪/parsed[⍸({(∊⍵[2])≡,'a'}⍤1)parsed;4]
     
          ⍝ Find all "href" attributes and obtain their values
     uris←attrs[⍸({⍵[1]≡⊂'href'}⍤1)attrs;2]
     
          ⍝ Filter urls with PDF extension (case-insensitive)
     pdfs←,uris[⍸{⍴('pdf$'⎕S 0⍠1)⍵:1 ⋄ 0}¨uris]
     
          ⍝ 1) Parse the domain and schema from the original URL.
          ⍝ 2) Add the domain and schema to the obtained URLs (if necessary).
     domain←{1=⍴⍵:⊃⍵ ⋄ 'https://www.dyalog.com/'}('^([^/]*//[^/]+/)'⎕S'\1')⍵
     {'http'≢4↑⎕C∊⍵:(domain,⍵) ⋄ ⍵}¨pdfs
 }

 ReadUPC←{
          ⍝ 2020 APL Problem Solving Competition Phase II
          ⍝ Problem 7, Task 3 - ReadUPC
     
          ⍝ Check the input for correctness:
          ⍝ - length is 95
          ⍝ - all items are either 0 or 1
          ⍝ - even parity
     95≠≢⍵:¯1
     ~(∧/∊∘0 1)⍵:¯1
     0≠2|+/⍵:¯1
     
          ⍝ Partition the boolean array
     B left M right E←((1@1 4 46 51 93)95⍴0)⊂⍵
     
          ⍝ Check B, M, E parts for correctness
     1 0 1≢B:¯1
     1 0 1≢E:¯1
     0 1 0 1 0≢M:¯1
     
          ⍝ Generate digit codes
     codes←((7⍴2)⊤⊢)¨13 25 19 61 35 49 47 59 55 11
     
          ⍝ Reflect left/right (if needed) and invert the right side
     LR←left{(⊂7↑⍺)∊codes:⍺,~⍵ ⋄ (⌽⍵),~⌽⍺}right
     
          ⍝ Convert to digits: partition into 12 parts, then look up among codes
     digs←¯1+codes⍳(84⍴(1,6⍴0))⊂LR
     
          ⍝ Final checks:
          ⍝ - where all digit codes located in the codes table?
          ⍝ - verify the "check digit"
     10∊digs:¯1
     (12⊃digs)≠CheckDigit 11↑digs:¯1
     
     digs       ⍝ Return the result
 }

 Steps←{
          ⍝ 2020 APL Problem Solving Competition Phase II
          ⍝ Problem 2, Task 1 - Steps
     
          ⍝ Default parameter
     ⍺←1
     
          ⍝ Special case for p=0: just return the first element
     ⍺=0:⍵[1]
     
          ⍝ My solution consists of three primary specialized solutions depending on
          ⍝ the value of p. Each solution is optimized for it's case.
     
          ⍝ If p=1 then it is the same as problem 5 from phase I:
          ⍝ 1) Generate a vector of integers from 0 to d, where d = to - from.
          ⍝ 2) Add "from" to this vector to obtain the result.
     ⍺=1:(⊃⍵)+0,(×d)×⍳|d←--/⍵
     
          ⍝ If p<0 then abs(⌊p) is the number of steps:
          ⍝ 1) Create vector of integers from 0 to n, where n is the number of steps
          ⍝ 2) Multiply by step size: (to-from)/n
          ⍝ 3) Add "from" to this vector to obtain the result.
          ⍝ 4) Replace the last element with the original "to" (⍵[2]) just to ensure
          ⍝    that it is integer and conforms to the requirement fromTo≡(⊣/,⊢/)
     ⍺<0:(⍵[2]@(n+1))(⊃⍵)+(n÷⍨--/⍵)×0,⍳n←|⌊⍺
     
          ⍝ If p>0 then it is the absolute step size:
          ⍝ 1) Calculate difference d = to - from.
          ⍝ 2) Calculate the number of steps n ← ⌈(|d)÷p
          ⍝ 3) Generate vector of integers from 0 to n.
          ⍝ 4) Multiply this vector by the direction of d and by the step size p.
          ⍝ 5) Add "from" to this vector.
          ⍝ 6) Replace the last element with "to" (⍵[2]).
     (⍵[2]@(n+1))(⊃⍵)+⍺×(×d)×0,⍳n←⌈⍺÷⍨|d←--/⍵
 }

 Weights←{
          ⍝ 2020 APL Problem Solving Competition Phase II
          ⍝ Problem 9, Task 1 - Weights
     
          ⍝ Read the mobile from file and format it into a 2D array
     M←⍕↑⊃(⎕NGET ⍵ 1)[1]
     
          ⍝ Find the distinct weight names.
          ⍝ Assumption: all characters other than " ┌─┴┐│" and newline are weights.
     N←∪({~⍵∊' ┌─┴┐│'}¨∊M)/∊M
     nw←≢N      ⍝ number of weights
     
          ⍝ Coefficients matrix: specifies the relationships between weights.
          ⍝ It is such a matrix that satisfies (C+.×W)≢(1,(nw-1)⍴0),
          ⍝ where W is the solution vector (numeric values of weights).
     C←(1@1)(1 nw)⍴0    ⍝ first weight is assumed to be 1 (for now)
     
          ⍝ Define recursive function for parsing
          ⍝ Returns a boolean vector for weights found in the sub-mobile (sub-tree)
          ⍝ Meanwhile, appends the matrix C as it goes (see the next function)
     descent←{                      ⍝ this function parses input vertically
         y←⍺+¯1+⌊/⍸'│'≠(⍺-1)↓M[;⍵]  ⍝ find first non-'│' from here down
         '┴'=M[y;⍵]:y explore ⍵     ⍝ explore new level if found
         (1@(N⍳M[y;⍵]))nw⍴0         ⍝ otherwise: turn weight name into a vector
     }
     
          ⍝ Parses a level and adds the resulting relations between weights into C
     explore←{                      ⍝ this function parses input horizontally
         r←'─'≠M[⍺;]                ⍝ find all non-horizontal bars in this row
         x1←⌈/⍸(¯1+⍵)↑r             ⍝ find first non-'─' on the left
         x2←⍵+⌊/⍸⍵↓r                ⍝ find first non-'─' on the right
         w1←(⍺+1)descent x1         ⍝ parse left sub-mobile
         w2←(⍺+1)descent x2         ⍝ parse right sub-mobile
         cfs←((⍵-x1)×w1)-(x2-⍵)×w2  ⍝ relationship between weights here (coefs)
         C⍪←(1 nw)⍴cfs÷∨/cfs        ⍝ divide these coefs by GCD and add to C
         w1+w2                      ⍝ return all the weights of this sub-mobile
     }
     
          ⍝ Find the topmost link: it will be the starting point for parsing.
          ⍝ Assumption: there are no empty lines above the mobile.
     x←⌊/M[1;]⍳'┴│'
     
     ign←1 descent x        ⍝ parse the input to find the matrix C
     
     W←(⌹C)[;1]     ⍝ multiplying the inverse of C by 1 0 ... 0 is first column
     ,(∨/W)÷⍨W      ⍝ divide the solution by generalized GCD to obtain an
                         ⍝ integer solution
 }

 WriteUPC←{
          ⍝ 2020 APL Problem Solving Competition Phase II
          ⍝ Problem 7, Task 2 - WriteUPC
     
          ⍝ Check the input for correctness:
          ⍝ 1) Vector size is expected to be 11
          ⍝ 2) Return if any number is not an integer from the range 0..9
     11≠≢⍵:¯1
     (∨/(⊢≠⌊)∨0∘≤⍲≤∘9)⍵:¯1
     
          ⍝ Perform the conversion:
          ⍝ 1) Generate a vector of codes for each digit
          ⍝    (by encoding 2-digit numbers to binary).
          ⍝ 2) Encode first 6 digits using the original codes.
          ⍝ 3) Encode last 5 digits AND the check digit using the reverse codes.
          ⍝ 4) Return the final boolean vector.
     codes←((7⍴2)⊤⊢)¨13 25 19 61 35 49 47 59 55 11
     LL←∊codes[1+6↑⍵]
     RR←∊~codes[1+(¯5↑⍵),CheckDigit ⍵]
     1 0 1,LL,0 1 0 1 0,RR,1 0 1
 }

 pv←{
          ⍝ 2020 APL Problem Solving Competition Phase II
          ⍝ Problem 5, Task 2 - pv
     
          ⍝ 1) Find the accumulated interest rate for all future terms (×\1+⍵).
          ⍝ 2) Discount cashflow amounts by dividing them by the accumulated
          ⍝    interest rate. This finds present value of each such amount.
          ⍝ 3) Add up all the present values of the amounts to find the total
          ⍝    present value.
     
     +/⍺÷×\1+⍵
 }

 revp←{
          ⍝ 2020 APL Problem Solving Competition Phase II
          ⍝ Problem 4, Task 1 - revp
     
          ⍝ If input is too small: return an empty 2-column matrix
     4>≢⍵:0 2⍴⍬
     
          ⍝ Determines if the parameter is a reverse palindrome
     pal←{⍵≡⌽'ATCG'['TAGC'⍳⍵]}
     
          ⍝ Looks for reverse palindromes of length ⍵ in array ⍺.
          ⍝ Uses ⍵-Wise Reduce operation on the array for this purpose.
     k←{⍵(⊢,⊣)¨⍸pal¨⍵,/⍺}
     
          ⍝ Iteratively look for reverse palindromes of length 4 to (12⌊≢⍵).
          ⍝ Because reverse palindromes of odd size are impossible,
          ⍝ odd lengths are skipped for improved performance.
     ↑⊃,/⍵∘k¨(2+2×⍳5⌊⌊2÷⍨¯2+≢⍵)
 }

 rr←{
          ⍝ 2020 APL Problem Solving Competition Phase II
          ⍝ Problem 5, Task 1 - rr
     
          ⍝ This can be calculated elegantly with the following operations:
          ⍝ 1) Find the accumulated interest rate (IR) for each term (IR←×\1+⍵).
          ⍝ 2) Deprecate the cashflow amounts by dividing them by accumulated IR.
          ⍝    This finds the present value of all the amounts.
          ⍝ 3) Accumulate all the present values of the amounts to find the total
          ⍝    present value at each term.
          ⍝ 4) Multiply by IR to find future values at each term.
     
          ⍝ This way the money that was deposited in a term is not changed,
          ⍝ but the money that came from the previous term is multiplied by
          ⍝ the current interest rate for each term arriving to correct answer.
     
     IR×+\⍺÷IR←×\1+⍵
 }

 sset←{
          ⍝ 2020 APL Problem Solving Competition Phase II
          ⍝ Problem 4, Task 2 - sset
     
          ⍝ Recursive exponentiation by squaring (modulus 1e6)
          ⍝ Standard algorithm.
     
     ⍵>1:1000000|(1+2|⍵)×(∇⌊2÷⍨⍵)*2 ⋄ 2
 }

:EndNamespace 
:EndNamespace 
