# APL Problem Solving Competition 2020
  
My solutions for the [2020 APL Problem Solving Competition](https://www.dyalog.com/student-competition.htm):

- [Phase I](Contest2020_Phase1.apl)
- [Phase II](Contest2020_Phase2.dyalog)

Developed using Dyalog APL 18.0.

## Phase II highlights

 - Balance problem (P.8) was solved using the Horowitz—Sahni algorithm with O(N×2<sup>N/2</sup>) time complexity.
   - Two more approaches are used for improved performance in special cases: recursive and brute force.
   - I also tried the [pseudo-polynomial dynamic programming](https://github.com/amakukha/apl-contest-2020/blob/bd348cb8d9bb00a845d36b629d61ff415a775f51/Contest2020_Phase2.dyalog#L55) 
     approach, but it was consistently outperformed by the recursive branch and bound method with greedy heuristic.
 - Simple exponentiation by squaring: `sset←{⍵>1:1e6|(1+2|⍵)×(∇⌊⍵÷2)*2 ⋄ 2}` (P.4.2)
 - Simple solution for the cashflow problem: `rr←{AR×+\⍺÷AR←×\1+⍵}` (P.5.1)
   - It's the fastest and seemed to be the most “array-based”. In a production setting, however, I'd rather go with
     a [recurrent solution](https://github.com/amakukha/apl-contest-2020/blob/c9155e8436038cc155e8c9f966f4ab93d3c4404d/Contest2020_Phase2.dyalog#L468) instead,
     which avoids the division operation.

## Result
I won the Grand Prize (2500 USD + invitation to [Dyalog '20](https://www.dyalog.com/user-meetings/dyalog20.htm) conference).

## My take
Totally recommended!

This was a lot of fun and Dyalog APL is a useful tool to learn.

## Advice for future contestants
 - Use [dfns](https://aplwiki.com/wiki/Dfn) instead of [tradfns](https://aplwiki.com/wiki/Defined_function).
 - Use `dfns.cmpx` for profiling.
 - Use [APLcart.info](https://aplcart.info) to find idioms.
 - Always use `]Boxing on -style=max -trains=tree`
 - Study algorithms.

If you want to learn more, you can [watch my talk at Dyalog'20](https://www.youtube.com/watch?v=YB5wNW68-lM) titled "How I Won the APL Problem Solving Competition".
