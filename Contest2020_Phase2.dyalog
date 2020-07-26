:Namespace Contest2020
⍝ === VARIABLES ===

AboutMe←''

FilePath←'/tmp/'

Reaction←''


⍝ === End of variables definition ===

(⎕IO ⎕ML ⎕WX ⎕PP)←1 1 3 9

:Namespace Problems
(⎕IO ⎕ML ⎕WX ⎕PP)←1 1 3 9

 Balance←{
          ⍝ 2020 APL Problem Solving Competition Phase II
          ⍝ Problem 8, Task 1 - Balance
     
          ⍝ 1) Find GCD of the numbers (∨/⍵). If it's 0, make it 1 (avoid ÷0).
          ⍝ 2) Negate GCD if all the numbers are non-positive (allows to use
          ⍝    the recursive approach later).
          ⍝ 3) Divide numbers by the obtained GCD. (Allows to perform the quick
          ⍝    "odd total" check in more cases. It also reduces the magnitude of
          ⍝    the numbers speeding up the recursive approach.)
          ⍝ 4) Find the half of the total sum of these reduced numbers.
          ⍝ 5) "Odd total" check: return ⍬ if the half is not integer.
          ⍝    (Cannot split the numbers in two parts with equal sums.)
     nums←⍵÷gcd←{(-⍣(∧/0∘≥⍵))1⌈∨/⍵}⍵
     half≠⌊half←2÷⍨+/nums:⍬
     
          ⍝ Next there are two approaches with different time complexities.
     
          ⍝ Algorithm A: Recursive search (with greedy optimization).
          ⍝ This approach only works for non-negative numbers.
          ⍝ Otherwise, it performs better than Algorithm B when the
          ⍝ numbers are smaller or there are more numbers.
     th←64000÷2*(0⌈20-≢⍵)   ⍝ empiric threshold for when A works faster than B
     (half<th)∧(∧/0∘≤)nums:(gcd×⊢)BalanceRecursive nums
     
          ⍝ Algorithm B: Matrix multiplication. Time complexity: O((≢nums)×2*≢nums).
          ⍝ The running time doesn't depend on the magnitude of the numbers as much.
          ⍝ This approach also finds all possible solutions at once.
          ⍝ Steps:
          ⍝ 1) Assume that the first number will go to the first part.
          ⍝    This breaks symmetry and reduces the search space by half.
          ⍝    It also ensures that each part has at least one element
          ⍝    (even when the input consists entirely of zeroes).
          ⍝ 2) Consider all possible combinations for the remaining numbers.
          ⍝    For this, generate matrix G of all boolean vectors of size ¯1+≢⍵.
          ⍝ 3) Multiply this matrix by nums to get the sums of each possible subset.
          ⍝ 4) See if there is a subset which sums to the half of the total sum less
          ⍝    the first number.
          ⍝ 5) If there is no such subset return ⍬.
          ⍝ 6) Otherwise split the numbers into two groups and return them.
          ⍝    One group represents the found subset (together with the first
          ⍝    number) and another – all the other numbers.
     
     sz←¯1+≢⍵                               ⍝ vector size (≤19)
     bin←(sz⍴2)⊤⊢                           ⍝ function to convert to binary vec
     G←bin ¯1+⍳2*sz                         ⍝ generate all the boolean vectors
     si←((1↓nums)+.×G)⍳half-⊃nums           ⍝ find a solution index (steps 3-4)
     si>2*sz:⍬                              ⍝ return ⍬ if there is no solution
     (mask/⍵)((~mask←1,bin ¯1+si)/⍵)        ⍝ split nums as indicated by index
 }

 BalanceRecursive←{
          ⍝ Branch and bound approach for the Balancing the Scales problem.
          ⍝ Works faster than matrix multiplication approach for small total sums.
     
          ⍝ 1) Find the half of the total sum (if it's not provided by the caller).
          ⍝ 2) Return ⍬ if it's odd (cannot split in two parts with equal sums).
     ⍺←2÷⍨+/⍵ ⋄ ⍺≠⌊half←⍺:⍬
     
          ⍝ 1) Sort the numbers in descending order (for the "greedy" heuristic).
          ⍝ 2) Calculate sums of all remaining values for each stage of search.
     rem←1↓⌽+\⌽nums←⍵[⍒⍵]
     
          ⍝ Recursive search helper.
          ⍝ Takes current sum on the left, current mask on the right.
          ⍝ Returns the mask for a solution; otherwise ⍬.
     rec←{
         ⍺=half:⍵                   ⍝ arrived to a solution: return it
         (half<⍺)∨(≢nums)=≢⍵:⍬      ⍝ cap bounding or end of search: return ⍬
         half>⍺+rem[≢⍵]:⍬           ⍝ cup bounding (sum is too small): return ⍬
         r←(⍺+nums[1+≢⍵])∇ ⍵,1      ⍝ try to include the current number
         ⍬≢r:r                      ⍝ solution found: return it
         ⍺ ∇ ⍵,0                    ⍝ try to exclude the current number
     }
     
          ⍝ Start the recursive search including the first number at once
          ⍝ (this is to break symmetry and reduce the search space).
     ⍬≡mask←(⊃nums)rec,1:⍬          ⍝ find a solution; return ⍬ if not found
     mask←(≢nums)↑mask              ⍝ pad the mask with zeroes if needed
     (mask/nums)((~mask)/nums)      ⍝ split numbers according to mask
 }

 CheckDigit←{
          ⍝ 2020 APL Problem Solving Competition Phase II
          ⍝ Problem 7, Tasl 1 - CheckDigit
     
          ⍝ Directly derived from check digit definition:
          ⍝ 1) Find dot product of the first 11 digits and the vector 3 1 3 ... 1 3.
          ⍝ 2) Negate it and find the residue modulus 10 – this is the check digit.
     
     10|-(11⍴3 1)+.×11↑⍵
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
     
          ⍝ 1) Load the template file, find all the at signs and find a
          ⍝    partitioning of text based on positions of the at signs.
          ⍝ 2) Modify the partitioning to place every other at sign into a single
          ⍝    partition with the preceding at sign.
          ⍝    This is achieved by decrementing values at every other at sign
          ⍝    position in the partitioning.
     parts←1++\ats←'@'=template←⊃⎕NGET ⍺
     parts[⍸(≠parts)∧ats∧(2|parts)]-←1
     
          ⍝ A helper function to process partitions
     replace←{
              ⍝ 1) Return the parameter without changes if it's not a merge area
              ⍝    (that is if it doesn't start and end with an at sign).
              ⍝ 2) Obtain the name of the merge area. If it's empty: return at sign.
              ⍝ 3) Look for the merge area name in the namespace.
              ⍝    Return the formatted value of the variable if it's there.
              ⍝ 4) Return "???" otherwise.
     
         ('@'≠¯1↑⍵)∨(1≥≢⍵)∨'@'≠⊃⍵:⍵
         0=≢name←¯1↓1↓⍵:'@'
         (⊂name)∊names:⍕ns⍎name
         '???'
     }
     
          ⍝ 1) Partition the template.
          ⍝ 2) Replace all the merge areas.
          ⍝ 3) Concatenate the resulting strings.
     ,/replace¨parts⊆template
 }

 PastTasks←{
          ⍝ 2020 APL Problem Solving Competition Phase II
          ⍝ Problem 3, Task 1 - PastTasks
     
          ⍝ 1) GET the web page via HTTP.
          ⍝ 2) Parse XML into a matrix.
     res←HttpCommand.Get ⍵
     dat←⎕XML res.Data
     
          ⍝ Helper function which finds all "href" attribute values by tag name.
     getUris←{
              ⍝ 1) Find all elements by tag name and obtain their attributes.
              ⍝ 2) Check if result was not empty.
              ⍝ 3) Find all "href" attributes and return their values.
         attrs←⊃⍪/dat[⍸((⊂,⍵)∘{⍵[2]≡⍺}⍤1)dat;4]
         0=≢attrs:⍬     ⍝ sanity check
         attrs[⍸({⍵[1]≡⊂'href'}⍤1)attrs;2]
     }
     
          ⍝ 1) Retrieve all URLs from "A" tags. Return ⍬ is nothing was found.
          ⍝ 2) Filter urls with PDF file name extension (case-insensitive).
          ⍝ 3) Get the address from the "base" tag.
          ⍝ 4) Add the base address to the obtained relative URLs.
     0=≢uris←getUris'a':⍬
     pdfs←{({⊃⍴('\.pdf$'⎕S 0⍠1)⍵}¨⍵)/⍵}uris
     base←{0≠≢⍵:⊃⍵ ⋄ ''}getUris'base'
     (base,⊢)¨pdfs
 }

 ReadUPC←{
          ⍝ 2020 APL Problem Solving Competition Phase II
          ⍝ Problem 7, Task 3 - ReadUPC
     
          ⍝ Perform some checks for the input correctness:
          ⍝ - input is a vector of length 95
          ⍝ - all its elements are either 0 or 1
          ⍝ - the parity of bits is even
     (1≠⍴⍴⍵)∨95≠≢∊⍵:¯1
     ~(∧/∊∘0 1)⍵:¯1
     2|+/⍵:¯1
     
          ⍝ Partition the boolean vector into logical parts
     B left M right E←((1@1 4 46 51 93)95⍴0)⊂⍵
     
          ⍝ Check B, M, E parts: convert binary vector to integer and compare
          ⍝ with the numeric value 1365 (which is (11⍴1 0) in binary).
     1365≠2⊥B,M,E:¯1
     
          ⍝ Decode the digits:
          ⍝ 1) Swap and reverse left and right parts if the first seven bits have
          ⍝    even parity. (This is to handle the reverse scanning order.)
          ⍝ 2) Invert the right part, merge two parts into a single boolean vector.
          ⍝ 3) Partition it into 12 chunks, then convert them into integers and look
          ⍝    those integers up in the vector of expected values.
          ⍝ 4) Subtracting 1 from the indices obtains the digit values.
     LR←left{2|+/7↑⍺:⍺,~⍵ ⋄ (⌽⍵),~⌽⍺}right
     digs←¯1+{13 25 19 61 35 49 47 59 55 11⍳2⊥⍵}¨(84⍴1 0 0 0 0 0 0)⊂LR
     
          ⍝ Final checks:
          ⍝ - were all digit codes located in the codes vector?
          ⍝ - verify the "check digit"
     10∊digs:¯1
     (12⊃digs)≠CheckDigit 11↑digs:¯1
     
     digs       ⍝ Return the resulting digits
 }

 Steps←{
          ⍝ 2020 APL Problem Solving Competition Phase II
          ⍝ Problem 2, Task 1 - Steps
     
          ⍝ Default parameter
     ⍺←1
     
          ⍝ Special case for p=0: just return the first element
     ⍺=0:⍵[1]
     
          ⍝ My solution consists of three primary specialized solutions depending on
          ⍝ the value of p. Each solution is optimized for its case.
     
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
          ⍝ 3) Generate a vector of integers from 0 to n.
          ⍝ 4) Multiply this vector by the direction of d and by the step size p.
          ⍝ 5) Add "from" to this vector.
          ⍝ 6) Replace the last element with "to" (⍵[2]).
     (⍵[2]@(n+1))(⊃⍵)+⍺×(×d)×0,⍳n←⌈⍺÷⍨|d←--/⍵
 }

 Weights←{
          ⍝ 2020 APL Problem Solving Competition Phase II
          ⍝ Problem 9, Task 1 - Weights
     
          ⍝ 1) Read the diagram of a mobile from the file as a vector of lines (M).
          ⍝ 2) Find lines which exactly repeat the preceding lines and contain only
          ⍝    vertical bars (│) and spaces. Such lines don't bring any useful
          ⍝    information. (This filtering step allows to process files which are
          ⍝    very deep without running out of memory. For example, 10K characters
          ⍝    wide, 100K lines deep. Without filtering, such a file would be
          ⍝    represented by a matrix with 1 billion characters!)
          ⍝ 3) Remove the repeating lines and format the rest of the lines into a
          ⍝    character matrix (2D).
     q←~((∧/∊∘'│ ')¨M)∧0,2≡/M←⊃⎕NGET ⍵ 1
     M←⍕↑q/M
     
          ⍝ Find the distinct weight names to know how many variables are there.
          ⍝ Assumption: all characters other than " ┌─┴┐│" and newline are weights.
     N←∪' ┌─┴┐│'~⍨∊M
     
          ⍝ Coefficients matrix: specifies the relationships between weights.
          ⍝ It is such a matrix that satisfies (C+.×W)≡(1,(¯1+≢N)⍴0),
          ⍝ where W is the solution vector (numeric values of weights).
          ⍝ We have only one row at this point: to set the first weight as the unit.
     C←(1@1)(1(≢N))⍴0    ⍝ the first weight is provisionally set to be 1
     
          ⍝ Define recursive function for parsing.
          ⍝ Returns a boolean vector for weights found in the sub-mobile (sub-tree)
          ⍝ Meanwhile, appends the matrix C as it goes (see the next function)
     descent←{                      ⍝ this function parses input vertically
         y←⍺+¯1+⌊/⍸'│'≠(⍺-1)↓M[;⍵]  ⍝ find first non-'│' from here down
         '┴'=M[y;⍵]:y explore ⍵     ⍝ explore new lever if fulcrum is found
         (1@(N⍳M[y;⍵]))(≢N)⍴0       ⍝ otherwise: turn weight name into a vector
     }
     
          ⍝ Parses a lever and adds the resulting relations between weights into C
     explore←{                      ⍝ this function parses input horizontally
         d←(∊∘'┐┌')M[⍺;]            ⍝ find all lever edges in the current row
         l r←(⍳∘1)¨(⌽(⍵-1)↑d)(⍵↓d)  ⍝ offsets of the left and right edges
         w1←(⍺+1)descent ⍵-l        ⍝ parse left sub-mobile
         w2←(⍺+1)descent ⍵+r        ⍝ parse right sub-mobile
         cfs←(l×w1)-r×w2            ⍝ relationship between weights here (coefs)
         C⍪←cfs÷∨/cfs               ⍝ divide the coefs by GCD and catenate to C
         w1+w2                      ⍝ return all the weights of this sub-mobile
     }
     
          ⍝ Find the topmost link: it will be the starting point for parsing.
          ⍝ Assumption: there are no empty lines above the mobile.
     x←⌊/M[1;]⍳'┴│'
     
     ign←1 descent x        ⍝ parse the input to find the matrix C
     
          ⍝ 1) Obtain a solution by multiplying the inverse of C by vector 1 0 ... 0
          ⍝    (equivalent to just taking the first column of the inverse).
          ⍝ 2) Divide the solution vector by generalized GCD of its values to get
          ⍝    the smallest integer solution.
     ,W÷∨/W←(⌹C)[;1]
 }

 WriteUPC←{
          ⍝ 2020 APL Problem Solving Competition Phase II
          ⍝ Problem 7, Task 2 - WriteUPC
     
          ⍝ Check the input for correctness:
          ⍝ - input is a vector of length 11
          ⍝ - the elements are integers from the range 0..9
     (1≠⍴⍴⍵)∨11≠≢∊⍵:¯1
     (∨/(⊢≠⌊)∨0∘≤⍲≤∘9)⍵:¯1
     
          ⍝ Perform the conversion:
          ⍝ 1) Generate a vector of codes for each digit
          ⍝    (by encoding numbers in binary).
          ⍝ 2) Encode 11 digits and the check digit using the codes.
          ⍝ 3) Return the final boolean vector with the right part reversed.
     codes←((7⍴2)⊤⊢)¨13 25 19 61 35 49 47 59 55 11
     LR←∊codes[1+⍵,CheckDigit ⍵]
     1 0 1,(42↑LR),0 1 0 1 0,(~42↓LR),1 0 1
 }

 pv←{
          ⍝ 2020 APL Problem Solving Competition Phase II
          ⍝ Problem 5, Task 2 - pv
     
          ⍝ 1) Find the accumulated interest rate for all future terms (×\1+⍵).
          ⍝ 2) Discount cashflow amounts by dividing them by the accumulated
          ⍝    interest rate. This finds present values of each such amount.
          ⍝ 3) Add up all the present values of the amounts to find the total
          ⍝    present value.
     
     +/⍺÷×\1+⍵
 }

 revp←{
          ⍝ 2020 APL Problem Solving Competition Phase II
          ⍝ Problem 4, Task 1 - revp
          ⍝ Rosalind: Locating Restriction Sites
     
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
          ⍝ 1) Find the accumulated interest rate (AR) for each term (AR←×\1+⍵).
          ⍝ 2) Deprecate the cashflow amounts by dividing them by AR.
          ⍝    This finds the present value of all the amounts.
          ⍝ 3) Accumulate all the present values of the amounts to find the total
          ⍝    present value at each term.
          ⍝ 4) Multiply by AR to find future values at each term.
     
          ⍝ This way the money that was invested or withdrawn in a term is not
          ⍝ changed for that term, but the money that came from the previous terms
          ⍝ is multiplied by the current interest rate for each term arriving to the
          ⍝ correct recurrent relation:
          ⍝ Step 2) amounts[i]/AR[i]                     ⍝ ≡ PV[i]
          ⍝ Step 3) amounts[i]/AR[i] + APV[i-1]
          ⍝ Step 4) amounts[i] + APV[i-1]×AR[i]
          ⍝         amounts[i] + APV[i-1]×AR[i-1]×(1+rate[i])
          ⍝         amounts[i] + r[i-1]×(1+rate[i])      ⍝ ≡ r[i]
     
     AR×+\⍺÷AR←×\1+⍵
 }

 sset←{
          ⍝ 2020 APL Problem Solving Competition Phase II
          ⍝ Problem 4, Task 2 - sset
     
          ⍝ Because each element of a set can be included or excluded from a subset,
          ⍝ there are 2*n combinations. But we cannot just use the primitive
          ⍝ function Power (*), because it would exceed the limits for integer size.
          ⍝ Thus, we can do exponentiation by squaring.
     
          ⍝ Basically, we evaluate three cases:
          ⍝ 1) n is 1:
          ⍝       return 2, because there are two subsets of a set with one
          ⍝       element: empty set and itself.
          ⍝ 2) n is even:
          ⍝       find x*n÷2 modulus n (recursively), square it,
          ⍝       find the residue modulus 1e6 and return the result.
          ⍝ 3) n is odd and bigger than one:
          ⍝       find x*((n-1)÷2) modulus n (recursively), square it, multiply by 2
          ⍝       (because the extra element can be either included or excluded),
          ⍝       find the residue modulus 1e6 and return the result.
     
          ⍝ Taking the residue ensures that we always hold the lower 6 decimal
          ⍝ digits (up to 20 bits) towards the final product 2*n.
          ⍝ Squaring and multiplying by 2 makes the intermediate result up to 41
          ⍝ bits long. But this is well within the limits of 52-bit fraction part
          ⍝ of IEEE 754 64-bit floating-point format, which is used by Dyalog APL.
          ⍝ Thus we can arrive to the final answer precisely.
     
     ⍵>1:1000000|(1+2|⍵)×(∇⌊2÷⍨⍵)*2 ⋄ 2
 }

:EndNamespace 
:EndNamespace 
