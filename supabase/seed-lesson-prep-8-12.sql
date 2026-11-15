-- Course: "Planning Lessons with AI: Grade 8 to 12" (slug lesson-prep-8-12)
-- 10 modules x 3 lessons = 30 lessons, 4 quiz questions per module.
-- Plain English for teachers whose first language is not English. Example prompts (in > quotes) stay in English.
-- Re-running this file replaces the course (and any progress on it). Other courses are not touched.

delete from public.courses where slug = 'lesson-prep-8-12';

insert into public.courses (slug, title, summary)
values ('lesson-prep-8-12',
        $t$Planning Lessons with AI: Grade 8 to 12$t$,
        $t$A practical course for Senior Phase and FET teachers. Use AI to plan CAPS lessons that build higher-order thinking, prepare SBA tasks and memos, explain hard concepts in Maths, Sciences, Languages and Humanities, run matric revision, and deal with learners who use AI themselves — with you checking every step.$t$);

------------------------------------------------------------------
-- MODULE 1
------------------------------------------------------------------
do $seed$
declare c uuid; m uuid;
begin
    select id into c from public.courses where slug = 'lesson-prep-8-12';

    insert into public.modules (course_id, position, title, summary)
    values (c, 1, $t$Planning for Grades 8–12 with AI$t$,
            $t$What is different about planning for Senior Phase and FET, which documents to give the AI, and a prompt recipe for every lesson.$t$)
    returning id into m;

    insert into public.lessons (module_id, position, title, minutes, content_md, practice_task) values
    (m, 1, $t$Why AI helps high school teachers$t$, 8, $md$
**In this lesson** you will see where AI saves time for teachers in Grades 8–12, and where you must stay in charge.

## High school planning is heavy

In Grades 8–12 you teach **more content, at a deeper level**, often in **several classes and grades**. You also set and mark **SBA tasks**, prepare learners for **exams**, and support learners who are far behind. There is never enough time.

## Where AI helps

AI can give you a **first draft** quickly:

- a lesson plan that follows your ATP
- explanations of difficult concepts, in simple English
- examples and practice questions at different **cognitive levels**
- case studies, scenarios and data sets
- a draft test with a memo and a cognitive-level grid
- a revision programme for the term

## Where you stay in charge

In high school, mistakes are costly. A wrong formula, a wrong date or a wrong memo can cost learners marks in the final exam. So:

1. **You** choose the content from CAPS, the ATP and the **exam guidelines**.
2. The **AI** drafts.
3. **You** check every fact, step and answer.

## A real example

Mr Mabandla teaches Grade 11 Physical Sciences in Mthatha. He asked the AI to explain **Newton's Second Law** with examples from taxis. The explanation was good, but one calculation in the example had the wrong unit. He fixed it. In 20 minutes he had a lesson that felt local — and correct.

## Key words

| Word | Simple meaning |
|---|---|
| Senior Phase | Grades 7–9 (this course covers Grades 8 and 9) |
| FET | Further Education and Training phase: Grades 10–12 |
| SBA | School-Based Assessment — tasks done during the year that count for marks |

**Remember:** In high school, AI saves time on drafts. Your subject knowledge keeps it correct.
$md$,
     $t$Think of the topic you teach that takes you the longest to prepare. Ask the AI: "I teach Grade [grade] [subject]. Give me 3 ways you could help me prepare for the topic [topic]."$t$),

    (m, 2, $t$Give the AI CAPS, the ATP and the exam guidelines$t$, 10, $md$
**In this lesson** you will learn which documents to use so the AI's plan matches what learners will be examined on.

## Three documents

For Grades 8–12, three documents tell you **what** to teach and **how deep** to go:

- **CAPS** — the content and skills for each grade and subject
- **ATP** — what to teach in each week of the term
- **Examination guidelines** (FET) — which content is examinable, the format of the papers, and how marks are spread over cognitive levels

The AI does **not** reliably know the newest versions of these documents. It may mix up grades, or use old content that is no longer examined. So you must **paste the exact words**.

## A prompt with your documents

> I teach Grade 10 Geography, Term 2, Week 3. The ATP says: "[paste the ATP words]". The examination guidelines say learners must be able to: "[paste the relevant points]". Plan two 60-minute lessons that cover exactly this content. Do not add content that is not listed. Use simple English, because my learners' home language is isiXhosa.

## Also tell the AI about your class

- number of learners and the time of the period
- language level of your learners
- resources: textbooks, calculators, a lab or no lab, data or no data
- what learners did in the last lesson

Never include learners' **names, marks or personal details**.

## Key words

| Word | Simple meaning |
|---|---|
| Examination guidelines | A document that explains what will be in the final exam and how it is set |
| Examinable | Content that can be asked in the exam |
| Cognitive level | How hard the thinking is: remembering, applying, analysing, and so on |

**Remember:** Paste the ATP and exam guideline words. Do not trust the AI to remember them.
$md$,
     $t$Find the ATP (and exam guidelines, if you teach FET) for your next topic. Copy the exact words into a prompt and ask the AI to plan one lesson using only that content.$t$),

    (m, 3, $t$The high school lesson-prep recipe$t$, 10, $md$
**In this lesson** you will build one prompt recipe for Grades 8–12 lessons.

## RTCF, plus three extras

Use **R**ole, **T**ask, **C**ontext and **F**ormat, and add three things that matter in high school:

1. **Cognitive levels** — how much of the lesson is recall, and how much is higher-order thinking
2. **Exam link** — how this topic is usually asked in tests and exams
3. **Common mistakes** — what learners often get wrong

## The template

> You are an experienced Grade [grade] [subject] teacher in a South African public school in the Eastern Cape. Plan a [length]-minute lesson. ATP topic: "[exact words]". Exam guideline points: "[exact words]". My class: [number] learners, home language isiXhosa, learning in English. Resources: [list]. Use these headings: Lesson aim, Prior knowledge, Introduction (5 min), Explanation with 2 worked examples, Learner activity (with questions at low, middle and high cognitive levels), Common mistakes to watch for, How this is asked in exams, Homework. Use simple English. One to two pages.

## Teaching teenagers

Teenagers learn better when lessons are **relevant** and **active**. Add to your prompt:

- *"Connect the topic to learners' lives, careers or the local economy."*
- *"Include one short discussion question."*

## Keep improving the recipe

Every time the AI makes the same mistake, add a rule to your template. For example: *"Use SI units"*, *"Use South African examples and rand"*, *"Use the term 'learners', not 'students'."*

## Key words

| Word | Simple meaning |
|---|---|
| Prior knowledge | What learners already know before the lesson |
| Higher-order thinking | Analysing, evaluating and creating — not only remembering |
| Worked example | A problem solved step by step to show the method |

**Remember:** RTCF + cognitive levels + exam link + common mistakes = a strong high school lesson plan.
$md$,
     $t$Fill in the template for a lesson you will teach next week. Read the plan and check the "Common mistakes" section — do you agree with it from your experience?$t$);

    insert into public.quiz_questions (module_id, position, question, options, correct_index, explanation) values
    (m, 1, $t$Which grades are in the FET phase?$t$,
        $j$["Grades 4–6","Grades 10–12","Grades 7–9","Grades R–3"]$j$,
        1, $t$FET (Further Education and Training) is Grades 10, 11 and 12.$t$),
    (m, 2, $t$Why should you paste the exam guideline words into your prompt?$t$,
        $j$["The AI may not know the newest guidelines and may add content that is not examined","Because the AI likes long prompts","So that the answer is in isiXhosa","It is not useful"]$j$,
        0, $t$The AI's knowledge can be old or mixed up. Exact words keep the plan on examinable content.$t$),
    (m, 3, $t$What does "cognitive level" mean?$t$,
        $j$["The learner's age","The number of marks in a test","How hard the thinking is in a question","The grade a learner is in"]$j$,
        2, $t$Cognitive levels go from recall up to analysing, evaluating and solving new problems.$t$),
    (m, 4, $t$The AI keeps using American examples and dollars. What should you do?$t$,
        $j$["Stop using AI","Translate everything yourself every time","Accept it","Add a rule to your template: use South African examples and rand"]$j$,
        3, $t$Add a permanent rule to your template so the mistake does not happen again.$t$);
end
$seed$;

------------------------------------------------------------------
-- MODULE 2
------------------------------------------------------------------
do $seed$
declare c uuid; m uuid;
begin
    select id into c from public.courses where slug = 'lesson-prep-8-12';

    insert into public.modules (course_id, position, title, summary)
    values (c, 2, $t$Lessons that build thinking$t$,
            $t$Plan questions at different cognitive levels, explain hard concepts clearly, and connect lessons to learners' lives and careers.$t$)
    returning id into m;

    insert into public.lessons (module_id, position, title, minutes, content_md, practice_task) values
    (m, 1, $t$Questions at different cognitive levels$t$, 10, $md$
**In this lesson** you will use AI to write questions that move learners from remembering to deeper thinking.

## Why levels matter

Tests and exams in Grades 8–12 include questions at **different levels**. If learners only practise recall questions in class, they will struggle with the **higher-order** questions in the exam. Many subjects use a taxonomy such as **Bloom's** (and **Barrett's** for reading comprehension in languages).

| Level | Learners must… | Example verbs |
|---|---|---|
| Lower order | remember and understand | name, define, list, describe |
| Middle order | apply and analyse | calculate, compare, explain why |
| Higher order | evaluate and create | justify, predict, suggest a solution, design |

## Ask for a spread of questions

> I teach Grade 9 Natural Sciences. Topic: "Acids, bases and pH". Write 9 questions: 3 lower order, 4 middle order and 2 higher order. Label each question with its level and give a short memo. Use South African everyday examples (for example, vinegar, baking soda, soil in the garden).

## Check the labels

The AI often labels questions **wrongly**. A question that starts with "explain" can still be simple recall if the answer is in the textbook word for word. Check each label yourself. Also check your subject's **exam guidelines** — each subject spreads marks over the levels in its own way.

## Use the questions in the lesson

Do not keep higher-order questions only for tests. Use them in **class discussion** and **pair work**, so learners practise this kind of thinking with your support.

## Key words

| Word | Simple meaning |
|---|---|
| Taxonomy | A list that sorts questions from easy thinking to hard thinking |
| Lower-order question | A question about remembering or understanding facts |
| Higher-order question | A question that asks learners to judge, solve or create |

**Remember:** Ask for a spread of levels, and check the labels yourself.
$md$,
     $t$Ask the AI for 9 questions on your current topic: 3 lower, 4 middle, 2 higher order. Check every label. Change any that you think are labelled wrongly.$t$),

    (m, 2, $t$Explaining difficult concepts$t$, 10, $md$
**In this lesson** you will use AI to find clear explanations, analogies and examples for abstract ideas.

## Abstract ideas need bridges

Concepts like **electric potential, inflation, photosynthesis, irony or functions** are hard to see. Learners need a **bridge** from what they know to the new idea. An **analogy** is a good bridge.

> I teach Grade 11 Physical Sciences. Explain "electric potential difference" to learners whose home language is isiXhosa and who learn in English. Give: a simple definition, 2 analogies from everyday life in the Eastern Cape (for example, water from a tank or a river), a drawing I can make on the board, and 3 questions to check understanding. Tell me where each analogy breaks down.

## Ask where the analogy breaks down

Every analogy is **only partly true**. If you do not tell learners the limits, they may build a **misconception**. Asking the AI "where does this analogy break down?" helps you teach it carefully.

## Several explanations

When learners do not understand, you need a **different** explanation, not the same one louder. Ask the AI for three: one with a **diagram**, one with a **story or example**, and one **step by step**.

## Check the subject content

AI explanations can sound right but be **slightly wrong**. In high school, small errors matter. Compare the explanation with your **textbook** and your own subject knowledge before you teach it.

## Key words

| Word | Simple meaning |
|---|---|
| Abstract | Something you cannot see or touch, only think about |
| Analogy | Explaining a new idea by comparing it to something familiar |
| Misconception | A wrong idea that leads to repeated mistakes |

**Remember:** Use analogies as bridges — and tell learners where the bridge ends.
$md$,
     $t$Choose the hardest concept in your subject this term. Ask the AI for 2 analogies and where each one breaks down. Decide which one you will use.$t$),

    (m, 3, $t$Making lessons relevant: life and careers$t$, 8, $md$
**In this lesson** you will use AI to connect your subject to learners' lives, the Eastern Cape economy and future careers.

## "Why do we learn this?"

Teenagers often ask this question. When they see **why** a topic matters, they work harder. AI is good at finding **connections**.

> I teach Grade 10 Mathematics. Topic: "Exponential functions". Give me 5 real-life examples that learners in the Eastern Cape would understand (for example, savings at a bank, population growth, the spread of an illness), and 3 careers that use this mathematics. Write a 5-minute lesson introduction using one example.

## Local economy and careers

Ask for examples from **local industries**: agriculture and farming, the Coega and East London areas, the motor industry, tourism on the Wild Coast, health care, teaching, and small businesses. Learners in rural areas may not know about many careers. Your subject can open these doors.

## Check the career facts

The AI may give **wrong information** about study paths, university requirements or bursaries. For career facts, always check with **official sources**: university websites, the Department, or your Life Orientation teacher.

## Do not overdo it

A relevant example should **support** the content, not replace it. Five minutes of connection, then the CAPS content.

## Key words

| Word | Simple meaning |
|---|---|
| Relevant | Connected to learners' lives and interests |
| Career | A job or profession a person trains for |
| Local economy | The businesses and jobs in your area |

**Remember:** A good "why" makes learners want to learn the "what".
$md$,
     $t$Ask the AI for 3 real-life examples and 3 careers for your next topic. Choose one example for your lesson introduction. Check any career facts with an official source.$t$);

    insert into public.quiz_questions (module_id, position, question, options, correct_index, explanation) values
    (m, 1, $t$Which of these is a higher-order question?$t$,
        $j$["Define the word \"acid\".","List three bases.","Name the scale used for pH.","Suggest and justify a way to make acidic soil better for growing maize."]$j$,
        3, $t$Suggesting and justifying a solution asks learners to evaluate and create — higher-order thinking.$t$),
    (m, 2, $t$Why should you ask the AI where an analogy breaks down?$t$,
        $j$["So you can warn learners and avoid misconceptions","To make the lesson longer","Because analogies are always wrong","So learners can memorise it"]$j$,
        0, $t$Every analogy is only partly true. Knowing its limits helps you teach it safely.$t$),
    (m, 3, $t$The AI gives university entry requirements for a career. What should you do?$t$,
        $j$["Tell learners they are correct","Ignore careers completely","Check them with official sources such as university websites","Ask learners to check them on their own"]$j$,
        2, $t$Career and study information changes and the AI can be wrong. Check official sources.$t$),
    (m, 4, $t$The AI labels a question as "higher order", but the answer is in the textbook word for word. What is true?$t$,
        $j$["The label is correct","The label is probably wrong — it is really recall","Higher order means long","The AI never makes labelling mistakes"]$j$,
        1, $t$If learners can copy the answer from the textbook, it is a lower-order question. Check the AI's labels.$t$);
end
$seed$;

------------------------------------------------------------------
-- MODULE 3
------------------------------------------------------------------
do $seed$
declare c uuid; m uuid;
begin
    select id into c from public.courses where slug = 'lesson-prep-8-12';

    insert into public.modules (course_id, position, title, summary)
    values (c, 3, $t$Mathematics and Mathematical Literacy$t$,
            $t$Plan worked examples, practice sets and real-life contexts — and learn why every AI calculation must be checked.$t$)
    returning id into m;

    insert into public.lessons (module_id, position, title, minutes, content_md, practice_task) values
    (m, 1, $t$Worked examples and step-by-step methods$t$, 10, $md$
**In this lesson** you will use AI to prepare worked examples for Mathematics in Grades 8–12.

## Learners learn from examples

In Mathematics, learners learn a method by seeing **clear worked examples**, then trying **similar problems**. Preparing many good examples takes time. The AI can help.

> I teach Grade 11 Mathematics. Topic: "Solving quadratic inequalities". Give me 3 worked examples, from easy to harder. Show every step and write a short reason next to each step. Use the method: factorise, find critical values, use a number line or sketch, write the answer in interval notation. Then give 6 practice questions with answers.

## Tell the AI your method

Learners get confused when the AI uses a **different method** from the one you teach or from the textbook. Describe your method in the prompt, as in the example above.

## AI is weak at calculation

This is very important: **AI chat tools often make arithmetic and algebra mistakes**, even when the explanation sounds confident. Common problems:

- a sign error (+ instead of −)
- a wrong final answer in the memo
- a step that skips or changes a number

**Work through every worked example yourself** before you teach it. If you find one mistake, check everything.

## Use AI for the words, you for the maths

A good method: you choose or write the problems. Then ask the AI to write the **explanations in simple English**, the **reasons for each step**, or a list of **common errors**.

## Key words

| Word | Simple meaning |
|---|---|
| Worked example | A problem solved step by step to show the method |
| Method | The steps you follow to solve a type of problem |
| Sign error | A mistake with a plus or minus sign |

**Remember:** AI can explain maths well, but it can calculate badly. Check every step.
$md$,
     $t$Ask the AI for 3 worked examples on your current Maths topic, using your method. Work through each one yourself. Did you find any mistakes?$t$),

    (m, 2, $t$Mathematical Literacy: real-life contexts$t$, 10, $md$
**In this lesson** you will use AI to build Mathematical Literacy contexts that feel real for Eastern Cape learners.

## Maths Lit is about life

Mathematical Literacy uses **real contexts**: water and electricity tariffs, bank statements, loans, taxes, maps and plans, measurement, data and probability. Good contexts are **realistic, local and detailed**.

> I teach Grade 11 Mathematical Literacy. Create a realistic context about a family in Gqeberha comparing two cellphone contracts. Include a table of costs, data and minutes for both contracts. Then write 6 questions at different levels: 2 reading information, 2 calculations, 1 drawing a graph, and 1 recommending the better option with reasons. Give a full memo.

## Make numbers realistic

The AI may use **old or wrong prices**, tax brackets, interest rates or tariffs. For Maths Lit this matters, because learners must judge whether answers make sense. You can:

- give the AI **real numbers** from a current municipal bill, shop slip or bank brochure (with personal details removed)
- tell the AI: *"Use these exact prices: …"*
- check that totals and percentages are calculated correctly

## Use local documents

Local documents make lessons real: a **taxi fare table**, a **school fees letter**, a **spaza shop price list**, a **map of your town**. Type the information (without personal details) into the prompt and ask the AI for questions.

## Check the memo

As with Mathematics, the AI can make **calculation mistakes** in the memo. Check every total, VAT amount and percentage.

## Key words

| Word | Simple meaning |
|---|---|
| Context | The real-life situation used in a question |
| Tariff | A list of prices for a service, like electricity or water |
| Realistic | Close to real life |

**Remember:** Real numbers make real contexts. Give the AI the numbers; check its calculations.
$md$,
     $t$Find a real price list or bill (remove personal details). Type the numbers into a prompt and ask the AI for 6 Maths Lit questions at different levels with a memo. Check the memo.$t$),

    (m, 3, $t$Practice sets, revision and Grade 8–9 foundations$t$, 10, $md$
**In this lesson** you will use AI to make practice sets and to fill gaps in learners' foundations.

## Many learners have gaps

Many learners in Grades 8 and 9 (and even in FET) have gaps from primary school: **fractions, integers, place value, basic algebra**. Without these, new topics are very hard.

> Many of my Grade 8 learners struggle with operations with integers (negative numbers). Make a 15-minute catch-up activity: a quick explanation with a number line and temperatures, 10 practice questions from easy to harder, and 3 diagnostic questions I can use first to see who needs it.

## Diagnostic questions

**Diagnostic questions** help you find the gap before you teach. Ask the AI for 5 short questions that check prior knowledge for your next topic. Each wrong answer should point to a **specific misconception**.

## Practice in levels

Ask for practice sets with **three levels**: basic, grade level and challenge. Learners start where they are and move up.

## Mixed revision

Before tests, learners need **mixed practice** — questions from different topics together — so they learn to choose the right method.

> Make a 20-question mixed revision set for Grade 9 Mathematics, Term 3, covering: algebraic expressions, equations, and geometry of straight lines. Mix the order. Give a memo.

## Key words

| Word | Simple meaning |
|---|---|
| Foundation | Basic knowledge needed for later topics |
| Diagnostic question | A question that shows what a learner does not yet understand |
| Mixed practice | Questions from different topics together |

**Remember:** Find the gap first, then fill it. Then practise at the right level.
$md$,
     $t$Ask the AI for 5 diagnostic questions for your next Maths or Maths Lit topic. Use them at the start of the lesson and note (without names) what gaps you find.$t$);

    insert into public.quiz_questions (module_id, position, question, options, correct_index, explanation) values
    (m, 1, $t$What is true about AI chat tools and mathematics?$t$,
        $j$["They never make calculation mistakes","They can explain well but often make calculation mistakes","They cannot explain mathematics","They only work for Grade 12"]$j$,
        1, $t$AI can sound confident and still make sign errors or wrong final answers. Check every step.$t$),
    (m, 2, $t$How can you make Maths Lit numbers realistic?$t$,
        $j$["Let the AI guess prices","Use prices from 20 years ago","Give the AI real numbers from current bills or price lists, with personal details removed","Use dollars"]$j$,
        2, $t$Real, current numbers make the context believable and useful.$t$),
    (m, 3, $t$What is a diagnostic question?$t$,
        $j$["A question that shows what a learner does not yet understand","The last question in an exam","A question about health","A question with no answer"]$j$,
        0, $t$Diagnostic questions help you find gaps before you teach the new topic.$t$),
    (m, 4, $t$Why should you tell the AI which method you teach?$t$,
        $j$["The AI only knows one method","It makes the answer shorter","Methods do not matter","Learners get confused if examples use a different method from yours or the textbook's"]$j$,
        3, $t$Consistent methods help learners. Describe your method in the prompt.$t$);
end
$seed$;

------------------------------------------------------------------
-- MODULE 4
------------------------------------------------------------------
do $seed$
declare c uuid; m uuid;
begin
    select id into c from public.courses where slug = 'lesson-prep-8-12';

    insert into public.modules (course_id, position, title, summary)
    values (c, 4, $t$Physical Sciences and Life Sciences$t$,
            $t$Plan practical work safely with few resources, explain processes with diagrams, and prepare data and graph questions.$t$)
    returning id into m;

    insert into public.lessons (module_id, position, title, minutes, content_md, practice_task) values
    (m, 1, $t$Practical work with few resources$t$, 12, $md$
**In this lesson** you will use AI to plan practical investigations and experiments when your school has a small lab or no lab.

## Practicals are required

CAPS requires **practical work** in Natural Sciences, Physical Sciences and Life Sciences, and some practicals are **formal SBA tasks**. Many Eastern Cape schools have few chemicals and little equipment. AI can help you find **safe, low-cost alternatives** that still teach the same skills.

> I teach Grade 10 Physical Sciences. The prescribed practical is about "heating and cooling curve of water". My school has no thermometers that work above 100 °C and only a small gas burner. Suggest how I can do this practical safely with what I have, or what low-cost equipment I need. Give: aim, materials, method, a results table, safety precautions and 5 questions about the results.

## Check the prescribed practicals

Your subject's CAPS and **exam guidelines** list the **prescribed** practicals. Paste the details into your prompt. Do **not** let the AI replace a prescribed practical with a different one.

## Safety is your responsibility

Ask the AI for **safety precautions** and read them critically. Be careful with:

- heat sources and boiling liquids
- acids, bases and other chemicals
- glass, electricity and sharp tools

If you are not sure an activity is safe, **do not do it**. Ask your HOD or subject advisor.

## When you cannot do it

If an investigation is impossible at your school, ask the AI for **realistic sample results** that learners can analyse. Tell learners clearly that the data is a sample, not their own.

## Key words

| Word | Simple meaning |
|---|---|
| Prescribed practical | A practical task that CAPS says must be done |
| Safety precaution | A step taken to prevent harm |
| Sample results | Example data learners can analyse when they cannot do the experiment |

**Remember:** Keep the prescribed practical, find a safe way to do it, and check every safety note.
$md$,
     $t$Choose the next practical in your subject. Tell the AI exactly what equipment you have and ask for a safe way to do it. Check the safety precautions with a colleague or your HOD.$t$),

    (m, 2, $t$Processes, diagrams and models$t$, 10, $md$
**In this lesson** you will ask AI to help explain processes such as photosynthesis, meiosis, chemical bonding or electric circuits using diagrams and models.

## Processes have steps

Many Science topics are **processes**: a series of steps. Learners understand them better with **flow diagrams**, **labelled drawings** and **physical models**.

> I teach Grade 12 Life Sciences. Topic: "Protein synthesis". Break the process into 6 short steps in simple English. For each step, describe a simple board drawing. Then suggest a role-play where learners act as DNA, mRNA, tRNA and ribosomes. Give 5 questions, including one about a labelled diagram.

## Ask for board drawings

AI chat tools can **describe** a diagram, but their own drawings are often wrong. Ask for **a description of what to draw** and practise drawing it yourself. Use the **diagrams in your textbook** as the correct reference.

## Models from waste materials

Learners remember better when they **build models**: a cell from a plastic bag and seeds, a molecule from clay and sticks, a DNA ladder from paper strips. Ask:

> Suggest 3 models learners can make from waste materials to show the structure of DNA. Each must take less than 30 minutes in class.

## Check the science carefully

In Grade 12, exam marking is strict about **correct terms and order of steps**. Compare every AI explanation with your textbook and **past exam memos**.

## Key words

| Word | Simple meaning |
|---|---|
| Process | A series of steps that happen in order |
| Flow diagram | A drawing that shows steps with arrows |
| Model | A simple object that shows how something works or looks |

**Remember:** Steps, drawings and models help learners see a process. Check the terms against the textbook.
$md$,
     $t$Pick a process from your Science syllabus. Ask the AI for the steps in simple English, a board drawing description and a role-play or model idea. Compare the steps with your textbook.$t$),

    (m, 3, $t$Data, graphs and scientific investigations$t$, 10, $md$
**In this lesson** you will use AI to prepare questions on data, graphs and investigation skills.

## Skills that are always examined

Science exams always test **investigation skills**: identifying variables, writing a hypothesis, drawing graphs, reading tables and drawing conclusions. Learners need lots of practice with **new data**.

> I teach Grade 11 Life Sciences. Create a short investigation scenario about the effect of fertiliser on the growth of maize plants in a school garden. Give a table of realistic results. Then write questions: identify the independent and dependent variables, write a hypothesis, name 2 controlled variables, draw a line graph (give marking points for the graph), and write a conclusion. Give a memo.

## Check that the data makes sense

The AI sometimes invents data that **does not match** the story, or graphs that would look strange. Read the numbers. Do they show a clear pattern? Would a real experiment give these results?

## Graph marking points

Ask the AI for **graph marking points** like those in exam memos: title, labelled axes with units, correct scale, plotted points and the right type of graph. Compare them with a **recent exam memo** in your subject.

## Use the same words as the exam

Use the exact terms your subject uses: **independent variable, dependent variable, controlled variables, hypothesis, reliability, validity**. Tell the AI: *"Use the terms used in the South African NSC exams."*

## Key words

| Word | Simple meaning |
|---|---|
| Variable | Something that can change in an investigation |
| Hypothesis | A testable prediction |
| NSC | National Senior Certificate — the matric qualification |

**Remember:** New data, exam words and correct graph marking — then check that the data makes sense.
$md$,
     $t$Ask the AI for one investigation scenario with data for your subject and grade. Check that the data shows a clear pattern and that the graph marking points match a recent exam memo.$t$);

    insert into public.quiz_questions (module_id, position, question, options, correct_index, explanation) values
    (m, 1, $t$The AI suggests a different practical to replace a prescribed one. What should you do?$t$,
        $j$["Use the AI's practical instead","Keep the prescribed practical and find a safe way to do it with your resources","Skip practical work","Let learners choose"]$j$,
        1, $t$Prescribed practicals are required. Use AI to find a safe way to do them, not to replace them.$t$),
    (m, 2, $t$Why should you ask the AI to describe a diagram rather than draw it?$t$,
        $j$["AI drawings of scientific diagrams are often wrong","Descriptions are more colourful","Learners cannot read diagrams","The AI cannot read"]$j$,
        0, $t$AI-made diagrams are often inaccurate. Use its description and your textbook's diagram.$t$),
    (m, 3, $t$In an investigation, what is the independent variable?$t$,
        $j$["The result that is measured","Something that is kept the same","The variable that the investigator changes on purpose","The title of the graph"]$j$,
        2, $t$The independent variable is what you change on purpose, such as the amount of fertiliser.$t$),
    (m, 4, $t$What should you check in AI-made investigation data?$t$,
        $j$["That it has many decimals","That it is very long","That it is in colour","That the numbers make sense and show a clear pattern"]$j$,
        3, $t$Invented data can be unrealistic. Make sure it fits the story and shows a clear pattern.$t$);
end
$seed$;

------------------------------------------------------------------
-- MODULE 5
------------------------------------------------------------------
do $seed$
declare c uuid; m uuid;
begin
    select id into c from public.courses where slug = 'lesson-prep-8-12';

    insert into public.modules (course_id, position, title, summary)
    values (c, 5, $t$Languages: literature, writing and language$t$,
            $t$Teach set works without trusting the AI's memory of them, plan essays and transactional writing, and teach language in context.$t$)
    returning id into m;

    insert into public.lessons (module_id, position, title, minutes, content_md, practice_task) values
    (m, 1, $t$Teaching set works and literature$t$, 12, $md$
**In this lesson** you will use AI to plan literature lessons on novels, dramas, poems and short stories — safely.

## The AI may invent details about a set work

When you ask an AI about a novel or play, it may **mix up characters, invent scenes or give wrong quotes**. This is especially true for **South African and isiXhosa texts**, which the AI has read less about. Learners who learn invented details will lose marks.

## Paste the text you are teaching

The safe method: **paste the extract or poem** into the prompt (a page or a few pages), and ask the AI to work **only** from that text.

> I teach Grade 11 English First Additional Language. Below is an extract from our set work. Using ONLY this extract, give: a short summary in simple English, 5 contextual questions (2 literal, 2 interpretive, 1 evaluative) like those in the NSC Paper 2, and a memo. Quote only words that appear in the extract. [paste extract]

## Poetry

For poems, paste the **full poem**, then ask for help with **figures of speech, tone, theme and structure**. Ask the AI to **quote line numbers** so you can check each point.

## isiXhosa literature

For isiXhosa Home Language set works, AI support is weaker. Use it for **lesson structure and question types** (in English if needed), then write the content **yourself**, or with your subject team.

## Key words

| Word | Simple meaning |
|---|---|
| Set work | A prescribed book, drama or poem learners study for the exam |
| Extract | A short part of a longer text |
| Contextual question | A question about an extract that tests understanding of the whole text |

**Remember:** For literature, paste the text. Never trust the AI's memory of a set work.
$md$,
     $t$Paste a short extract or poem you are teaching into the AI. Ask for 5 contextual questions and a memo using ONLY that text. Check every quote against the book.$t$),

    (m, 2, $t$Essays and transactional writing$t$, 10, $md$
**In this lesson** you will plan essay and transactional writing lessons with AI.

## Writing is taught in steps

Good writing lessons follow the **process approach**: planning, drafting, editing, and the final copy. AI can help you prepare for each step.

> I teach Grade 10 English Home Language. Plan a series of 3 lessons on writing an argumentative essay on the topic "Cellphones should be allowed in school". Include: a mind-map planning frame, how to write a strong introduction and topic sentences, linking words for arguments, a model essay of 300 words at a Grade 10 level, and a simplified marking rubric based on content, structure and language.

## Transactional writing

Transactional texts include **formal letters, emails, reports, CVs, speeches, minutes and advertisements**. Ask the AI for **models** with the correct format, and then ask learners to **find the features** in the model.

> Write a model formal letter of complaint from a Grade 12 learner to the municipality about poor street lighting. Label the format features. Then give 5 questions that help learners find these features.

## Use models wisely

A model text shows **what good writing looks like**. But learners may copy it. Use the model for **analysis**, then give learners a **different topic** for their own writing.

## Check the format

Formats for letters and other texts can differ slightly. Use the format your **exam guidelines and textbook** require.

## Key words

| Word | Simple meaning |
|---|---|
| Process approach | Teaching writing step by step: plan, draft, edit, final copy |
| Transactional text | A practical text with a purpose: a letter, email, report or speech |
| Model text | A good example for learners to study |

**Remember:** Teach the steps, use models for analysis, and give learners a different topic to write on.
$md$,
     $t$Ask the AI for a model of one transactional text your learners must write this term. Label the features and check the format against your exam guidelines.$t$),

    (m, 3, $t$Comprehension and language in context$t$, 10, $md$
**In this lesson** you will use AI to prepare reading comprehension, summary and language-in-context practice for Grades 8–12.

## Fresh texts for practice

Learners need to practise on texts they have **not seen before**. AI can write texts on topics that interest teenagers.

> Write a 400-word article for Grade 12 English FAL learners on young people starting small businesses in the Eastern Cape. Use a mix of simple and complex sentences. Then write: 8 comprehension questions at different levels (literal, reorganisation, inference, evaluation, appreciation), a summary task (7 points in 90 words), and a memo.

## Language in context

CAPS teaches **language structures in context**: learners find and use grammar in real texts, cartoons and advertisements. Ask the AI to:

> Using the article above, write 8 language questions: active and passive voice, direct and reported speech, concord, and punctuation. Base each question on a sentence from the article.

## Visual texts

The AI cannot create a reliable cartoon or advertisement. But it can **describe** one you can draw, or you can use a **real advertisement** from a newspaper and ask the AI for questions about it.

## Check the facts in the text

If the AI writes about real people, businesses or statistics, **check them** or change them to fictional ones. A comprehension text should not teach wrong facts.

## Key words

| Word | Simple meaning |
|---|---|
| Comprehension | Understanding what you read |
| Summary | A short version that keeps only the main points |
| Visual text | A text with pictures: a cartoon, advertisement or poster |

**Remember:** Fresh texts, many question levels, and grammar taught from real sentences.
$md$,
     $t$Ask the AI for a 300-word text for your grade and 6 comprehension questions at different levels. Check any facts in the text and the levels of the questions.$t$);

    insert into public.quiz_questions (module_id, position, question, options, correct_index, explanation) values
    (m, 1, $t$What is the safest way to use AI when teaching a set work?$t$,
        $j$["Ask the AI to summarise the whole book from memory","Paste the extract and ask the AI to work only from that text","Let learners read the AI's summary instead of the book","Do not use the book"]$j$,
        1, $t$AI can invent scenes, characters and quotes. Pasting the text keeps it accurate.$t$),
    (m, 2, $t$How should learners use a model essay?$t$,
        $j$["Copy it for their own assignment","Ignore it","Study its features, then write on a different topic","Memorise it for the exam"]$j$,
        2, $t$Models show what good writing looks like. Learners should analyse them, not copy them.$t$),
    (m, 3, $t$Which of these is a transactional text?$t$,
        $j$["A formal letter of complaint","A poem","A short story","A novel"]$j$,
        0, $t$Transactional texts have a practical purpose, such as letters, emails, reports and speeches.$t$),
    (m, 4, $t$Why is AI support weaker for isiXhosa set works?$t$,
        $j$["isiXhosa literature is not examined","isiXhosa has no literature","The AI refuses isiXhosa","The AI has read much less about isiXhosa texts, so it makes more mistakes"]$j$,
        3, $t$AI tools have less information about isiXhosa texts, so the teacher must provide and check the content.$t$);
end
$seed$;

------------------------------------------------------------------
-- MODULE 6
------------------------------------------------------------------
do $seed$
declare c uuid; m uuid;
begin
    select id into c from public.courses where slug = 'lesson-prep-8-12';

    insert into public.modules (course_id, position, title, summary)
    values (c, 6, $t$Commerce and Humanities subjects$t$,
            $t$Plan case studies for EMS, Accounting, Business Studies and Economics, source-based History lessons, and Geography mapwork and data.$t$)
    returning id into m;

    insert into public.lessons (module_id, position, title, minutes, content_md, practice_task) values
    (m, 1, $t$Case studies for EMS, Business Studies and Economics$t$, 10, $md$
**In this lesson** you will use AI to write case studies and scenarios that bring commerce subjects to life.

## Case studies are central

In **EMS**, **Business Studies** and **Economics**, learners must apply theory to **real situations**. Exams often use **case studies**. AI is very good at writing realistic, local scenarios.

> I teach Grade 11 Business Studies. Topic: "Business strategies". Write a 250-word case study about a fictional family business in Mthatha that sells building materials and faces competition from a new large store. Then write 6 questions: 2 identify from the case study, 2 explain, 1 discuss, and 1 recommend. Use the question verbs used in NSC Business Studies papers. Give a memo with marks.

## Use fictional businesses

Use **fictional** businesses and people in case studies. If you use a real company, the AI may state **wrong facts** about it, which is unfair to the company and confusing to learners.

## Economics: use real data carefully

For Economics topics like **inflation, unemployment and GDP**, learners need real data. The AI's figures may be **old or wrong**. Take current figures from **Stats SA** or the **South African Reserve Bank**, and give them to the AI to build questions.

## EMS in Grades 8 and 9

In EMS, learners begin with **the economy, entrepreneurship and financial literacy**. Ask for simple scenarios: a learner who sells sweets at school, a spaza shop, a car wash.

## Key words

| Word | Simple meaning |
|---|---|
| Case study | A story about a business or situation that learners analyse |
| Fictional | Made up, not real |
| Entrepreneurship | Starting and running your own business |

**Remember:** Fictional businesses, real data from official sources, and the exam's question verbs.
$md$,
     $t$Ask the AI for a 200-word case study about a fictional local business for your grade and topic, with 5 questions and a memo. Check the question verbs against a recent exam paper.$t$),

    (m, 2, $t$Accounting: transactions and practice$t$, 10, $md$
**In this lesson** you will use AI to prepare Accounting practice — and check it very carefully.

## Accounting needs lots of practice

Learners must practise **many transactions**: journals, ledgers, trial balances, financial statements and analysis. AI can create **new sets of transactions** quickly.

> I teach Grade 10 Accounting. Create 10 transactions for a fictional sole trader in Komani who sells school uniforms, for the month of March. Include cash and credit transactions. Then give the Cash Receipts Journal and Cash Payments Journal answers in table form, using the format in South African CAPS Accounting.

## AI makes accounting errors

Accounting needs **exact numbers and correct double entry**. AI often makes mistakes with:

- totals that do not add up
- debits and credits on the wrong side
- formats that are different from South African CAPS formats

**Do the solution yourself first**, or check every line. Use the AI mainly for **creating transactions and scenarios**, and for **explaining concepts** in simple English.

## Explaining concepts

> Explain the accounting equation (A = O + L) to Grade 10 learners in simple English, using an example of a learner who starts a small car wash business.

## Key words

| Word | Simple meaning |
|---|---|
| Transaction | A business event that involves money, like a sale or a payment |
| Double entry | Every transaction is recorded on a debit side and a credit side |
| Journal | A book where transactions are recorded first |

**Remember:** Let the AI create transactions. You check the answers line by line.
$md$,
     $t$Ask the AI for 8 transactions for your Accounting topic and its answer. Work out the answer yourself and compare. How many errors did the AI make?$t$),

    (m, 3, $t$History sources and Geography mapwork$t$, 12, $md$
**In this lesson** you will plan source-based History lessons and Geography mapwork and data lessons with AI.

## History: never trust the AI's facts alone

AI tools can **invent historical facts, quotes and sources**. In History, this is very serious. Learners must work with **real sources**.

The safe method:
1. Use **real sources** from your textbook, past exam papers or source booklets.
2. Paste the source into the prompt.
3. Ask the AI to write **source-based questions**.

> I teach Grade 12 History. Below are two sources about the 1976 Soweto uprising from our textbook. Write 8 source-based questions like those in the NSC History paper: comprehension, usefulness, reliability, comparing the two sources, and a paragraph question. Give a memo. [paste sources]

## History essays

Ask the AI to help learners **plan essays**: an essay frame, how to write a line of argument, and how to use evidence. But the **facts** must come from the textbook.

## Geography: mapwork and data

Mapwork needs **real topographic and orthophoto maps**. The AI cannot provide reliable maps, but it can help with:

- **calculation practice**: distance, area, gradient, bearings — check every answer
- **explanations** of map skills in simple English
- **data questions** on climate graphs or population tables you give it

> Write 6 gradient calculation questions for Grade 11 Geography with heights and distances I give: [list]. Show the formula and working, and give answers rounded to the nearest whole number.

## Key words

| Word | Simple meaning |
|---|---|
| Source | Evidence from the past: a photo, letter, speech, newspaper report |
| Reliability | How much you can trust a source |
| Gradient | How steep a slope is |

**Remember:** In History, real sources; in Geography, real maps. The AI writes the questions — you check them.
$md$,
     $t$Paste a source from your History textbook (or data from a Geography table) into the AI and ask for 6 questions with a memo. Check that the AI did not add any facts.$t$);

    insert into public.quiz_questions (module_id, position, question, options, correct_index, explanation) values
    (m, 1, $t$Why should case studies use fictional businesses?$t$,
        $j$["The AI may state wrong facts about real companies","Fictional businesses are always bigger","Real businesses are not allowed in exams","Learners do not like real businesses"]$j$,
        0, $t$Using fictional businesses avoids wrong facts about real companies.$t$),
    (m, 2, $t$Where should Economics teachers get current figures like inflation?$t$,
        $j$["From the AI's memory","From an old textbook only","From official sources like Stats SA or the Reserve Bank","From social media"]$j$,
        2, $t$Official sources give current, correct figures. The AI's numbers may be old.$t$),
    (m, 3, $t$What is the best use of AI in Accounting?$t$,
        $j$["Trust all of its totals","Create transactions and explain concepts, while you check every answer line by line","Let it mark learners' work without checking","Avoid all practice"]$j$,
        1, $t$AI can create practice material, but it often makes accounting errors.$t$),
    (m, 4, $t$What is the safe way to prepare source-based History questions with AI?$t$,
        $j$["Ask the AI to invent sources","Use the AI's quotes from memory","Ask learners to find sources online during the test","Paste real sources from the textbook and ask the AI for questions"]$j$,
        3, $t$AI can invent sources and quotes. Use real sources and let the AI write the questions.$t$);
end
$seed$;

------------------------------------------------------------------
-- MODULE 7
------------------------------------------------------------------
do $seed$
declare c uuid; m uuid;
begin
    select id into c from public.courses where slug = 'lesson-prep-8-12';

    insert into public.modules (course_id, position, title, summary)
    values (c, 7, $t$Assessment: tests, SBA tasks and memos$t$,
            $t$Plan tests with a cognitive-level grid, design SBA tasks and PATs that follow the guidelines, and write marking guidelines and feedback.$t$)
    returning id into m;

    insert into public.lessons (module_id, position, title, minutes, content_md, practice_task) values
    (m, 1, $t$Setting a test with a cognitive-level grid$t$, 12, $md$
**In this lesson** you will use AI to draft a test that matches CAPS and the cognitive-level weightings for your subject.

## Plan the test before writing questions

A good test starts with a **plan**: the topics, the marks for each topic, and the marks at each cognitive level. This plan is often called an **analysis grid**.

> I teach Grade 10 Life Sciences. I need a 50-mark test on "Cells and tissues", Term 1. First make an analysis grid: topics, marks per topic, and marks per cognitive level using these weightings from our exam guidelines: [paste weightings]. Then write the test with the question numbers matching the grid. Include multiple choice, a diagram question and one data question. Give a memo with marks next to each point.

## Paste your subject's weightings

Every subject has its own **weightings** for cognitive levels in the exam guidelines or CAPS. The AI may not know them. **Paste them**.

## Check the test carefully

Before learners write the test:

- **Write the test yourself** — this shows mistakes, unclear wording and wrong mark allocations.
- Check that every question is **inside the content** for the term.
- Check the **language**: short, clear sentences for learners whose home language is not English.
- Check the **memo**: every answer correct, with clear marking points.
- Check that the grid's totals add up and match the question paper.

## Key words

| Word | Simple meaning |
|---|---|
| Analysis grid | A table that plans marks per topic and per cognitive level |
| Weighting | The percentage of marks at each level |
| Mark allocation | How many marks each question or point gets |

**Remember:** Grid first, then questions. Write the test yourself before your learners do.
$md$,
     $t$Ask the AI for an analysis grid and a 25-mark test for a topic you are teaching, using your subject's weightings. Write the test yourself and fix any problems.$t$),

    (m, 2, $t$SBA tasks, projects and PATs$t$, 10, $md$
**In this lesson** you will use AI to design School-Based Assessment tasks, projects and Practical Assessment Tasks that follow the official requirements.

## Follow the official requirements

For SBA tasks — **assignments, projects, investigations, orals, practical tasks** and **PATs** — CAPS and your province give **requirements**: the type of task, the marks, and sometimes a set task. If a **common task** is given by the department or district, you **must use it**.

Use AI only where **you** design the task, and paste the requirements:

> I teach Grade 9 Natural Sciences. I must set a research project (formal assessment) for Term 3. The requirements are: [paste requirements]. Design a project about water quality in our community. Give: learner instructions in simple English, a timeline over 3 weeks, what learners must hand in, and a rubric with 5 criteria and level descriptors.

## Make tasks fair for all learners

Many learners do not have **internet, printers or money for materials**. Ask the AI to design tasks that can be done with **free resources**, the **school library**, **interviews with community members** or **observation**.

## Rubrics with clear descriptors

A good rubric describes **what each level looks like**, not only "good" or "poor". Ask:

> Rewrite this rubric so that each level has a clear description of what the learner's work looks like. Use simple English.

## Moderation

SBA tasks are **moderated** at school, district and provincial level. Keep your planning documents, the task, the rubric and the memo in your **file**, and make sure the task matches the requirements.

## Key words

| Word | Simple meaning |
|---|---|
| PAT | Practical Assessment Task — a practical project that counts for marks in some subjects |
| Rubric | A table that shows how a task will be marked at each level |
| Moderation | Checking that assessment is fair and at the right standard |

**Remember:** Official requirements first. AI helps with design, wording and rubrics.
$md$,
     $t$Take the requirements for one SBA task you must set. Ask the AI to design the task with free resources and a rubric with clear level descriptors. Check it against the requirements.$t$),

    (m, 3, $t$Marking guidelines and feedback$t$, 10, $md$
**In this lesson** you will use AI to write clear marking guidelines and useful feedback — without sharing learners' personal information.

## Clear marking guidelines

A good memo or **marking guideline** shows the **marking points**, **alternative answers** and **how marks are given**. This helps you mark fairly and quickly.

> Here is my Grade 11 Geography question and my memo. Improve the memo: add possible alternative answers learners might give, show where each mark is given with a tick, and add notes for the marker on open-ended answers. [paste question and memo]

## Feedback that helps learners improve

Feedback should tell learners **what they did well**, **what to fix** and **how**. You can use AI to prepare **common feedback comments** for typical mistakes.

> Learners in my Grade 10 class made these common mistakes in their essays: [list mistakes]. Write 8 short feedback comments in simple English that tell a learner what is wrong and one clear step to improve.

## Do not upload learners' work with names

Learners' work and marks are **personal information** under POPIA. If you paste a learner's paragraph to get ideas for feedback:

- **remove the name** and any personal details
- paste only a short part
- never paste marks lists or class lists

## The teacher decides the mark

Do not let the AI **give the final mark**. AI marking can be inconsistent and unfair. Use the AI to **prepare** the memo and comments; **you** mark.

## Key words

| Word | Simple meaning |
|---|---|
| Marking guideline | The memo with marking points and how marks are given |
| Alternative answer | A different answer that is also correct |
| Feedback | Information that helps a learner improve |

**Remember:** AI helps you prepare memos and comments. You mark, and you keep learners' information private.
$md$,
     $t$Paste one of your own test questions and its memo into the AI. Ask it to add alternative answers and marker notes. Decide which changes you will keep.$t$);

    insert into public.quiz_questions (module_id, position, question, options, correct_index, explanation) values
    (m, 1, $t$What should you do before learners write a test you made with AI?$t$,
        $j$["Write the test yourself and check the memo","Give it to learners without reading it","Make it longer","Remove the memo"]$j$,
        0, $t$Writing the test yourself shows mistakes in questions, wording and the memo.$t$),
    (m, 2, $t$The district gives a common SBA task. What should you do?$t$,
        $j$["Ask the AI to write a different task","Use the common task as required","Skip the task","Let learners choose their own task"]$j$,
        1, $t$If a common task is given, you must use it. AI is for tasks that you design yourself.$t$),
    (m, 3, $t$What is a rubric?$t$,
        $j$["A list of learners' names","A type of exam paper","A table showing how a task will be marked at each level","A school rule"]$j$,
        2, $t$A rubric describes what work at each level looks like, so marking is fair and clear.$t$),
    (m, 4, $t$Who should decide a learner's final mark?$t$,
        $j$["The AI","Another learner","The principal only","The teacher"]$j$,
        3, $t$AI marking can be inconsistent and unfair. The teacher marks and decides.$t$);
end
$seed$;

------------------------------------------------------------------
-- MODULE 8
------------------------------------------------------------------
do $seed$
declare c uuid; m uuid;
begin
    select id into c from public.courses where slug = 'lesson-prep-8-12';

    insert into public.modules (course_id, position, title, summary)
    values (c, 8, $t$Exam preparation and matric revision$t$,
            $t$Plan revision programmes, use past papers well, and teach exam technique for Grade 12 and other exam grades.$t$)
    returning id into m;

    insert into public.lessons (module_id, position, title, minutes, content_md, practice_task) values
    (m, 1, $t$Planning a revision programme$t$, 10, $md$
**In this lesson** you will use AI to plan a revision programme for the term or for the final exams.

## Revision needs a plan

Many teachers revise by "doing past papers" without a plan. A good revision programme **starts with the weakest topics**, uses **different activities**, and fits the **time you really have**.

> I teach Grade 12 Physical Sciences. I have 6 weeks before the preliminary exams, with 4 periods of 60 minutes a week, plus 2 Saturday classes. Based on our class's last test, the weakest topics are: [list topics]. Make a revision programme in a table: week, topic, activity (explanation, worked examples, past paper questions, group work, quick test), and homework. Spend more time on the weakest topics.

## Use your data — without names

Look at your learners' **test results by question or topic**, not by learner name. Tell the AI which topics were weakest. This is called **data-driven revision**.

## Mix the activities

Revision should not only be "learners write past papers". Ask for:

- short **re-teaching** of key concepts
- **worked examples** of typical exam questions
- **peer teaching** in groups
- **short timed quizzes** to build speed
- **mixed questions** from different topics

## Grades 9 and 11 too

Grade 9 and Grade 11 learners also need good exam preparation. The same method works: weak topics first, a plan, and mixed activities.

## Key words

| Word | Simple meaning |
|---|---|
| Revision programme | A plan for going over work before exams |
| Data-driven | Based on results and evidence |
| Preliminary exam | The trial exam before the final Grade 12 exams |

**Remember:** Revise with a plan, start with the weakest topics, and mix the activities.
$md$,
     $t$Look at your last test results by topic (not names). Ask the AI for a 4-week revision programme that spends most time on the weakest topics.$t$),

    (m, 2, $t$Using past papers well$t$, 10, $md$
**In this lesson** you will use AI to get more value from past exam papers.

## Past papers are gold

Past NSC and provincial papers show **how questions are asked**, the **language** of the exam, and the **marking standard**. You can download them from the Department of Basic Education website.

## Analyse question types

Paste several questions on one topic from different years and ask:

> Here are questions on "Euclidean geometry" from 4 past Grade 12 Mathematics papers. What types of questions are asked most often? What skills do they test? Make a list of the 5 most common question types with one example each. [paste questions]

## Make similar practice questions

When learners have done all the past papers, ask the AI for **new questions in the same style**:

> Here is a past paper question and its memo. Write 3 new questions in the same style and at the same level, with different numbers or contexts, and a memo for each. [paste question and memo]

**Check every new question and memo.** The AI may change the level, or make mistakes in the memo.

## Learn from the examiner's reports

The **diagnostic reports** published with NSC results explain **common learner mistakes** for each question. Paste a section into the AI and ask for a **lesson to fix those mistakes**.

## Key words

| Word | Simple meaning |
|---|---|
| Past paper | A question paper from a previous exam |
| Diagnostic report | A report that explains how learners performed and their common mistakes |
| Same style | Similar format, language and level |

**Remember:** Past papers show the standard. AI can analyse them and make more practice in the same style.
$md$,
     $t$Paste 3 past exam questions on one topic into the AI. Ask what skills they test and for 2 new questions in the same style. Check the memos.$t$),

    (m, 3, $t$Teaching exam technique$t$, 8, $md$
**In this lesson** you will plan short lessons that teach learners how to write exams well.

## Knowing the work is not enough

Many learners **know the work** but lose marks because of **exam technique**: they misread the question, run out of time, or do not show working. These skills can be taught.

## Understanding question verbs

Learners must know what **"describe", "explain", "discuss", "evaluate", "calculate"** and other verbs ask for. Ask:

> Make a one-page table for Grade 12 learners of the 12 most common question verbs in NSC [subject] papers. For each verb: what it means in simple English, what the answer should include, and one example question with a model answer.

Check the meanings against your subject's **exam guidelines** — some subjects define the verbs differently.

## Time management

> A Grade 12 learner writes a 150-mark paper in 3 hours. Make a simple guide on how to plan time: reading time, how many minutes per mark, which questions to do first, and when to check answers.

## Show working and follow the format

Teach learners to **show working** in calculations (they can get marks even if the final answer is wrong), to **number answers correctly**, and to **write in full sentences** where needed. Ask the AI for a short **checklist** learners can use in every exam.

## Key words

| Word | Simple meaning |
|---|---|
| Exam technique | The skills of answering exam questions well |
| Question verb | The instruction word that says what to do, like "explain" |
| Show working | Write down every step, not only the answer |

**Remember:** Teach the work, and teach how to show it in the exam.
$md$,
     $t$Ask the AI for a table of the 10 most common question verbs in your subject with meanings and model answers. Check the meanings against your exam guidelines and share it with your class.$t$);

    insert into public.quiz_questions (module_id, position, question, options, correct_index, explanation) values
    (m, 1, $t$Where should a revision programme spend the most time?$t$,
        $j$["On the easiest topics","On the weakest topics, based on test results","Only on the last topic taught","On topics that are not in the exam"]$j$,
        1, $t$Data-driven revision starts with the topics where learners scored lowest.$t$),
    (m, 2, $t$The AI writes new questions in the style of a past paper. What must you do?$t$,
        $j$["Check the level of the questions and the memo","Use them without reading","Tell learners they are from the real exam","Remove the memo"]$j$,
        0, $t$AI can change the level or make memo mistakes. Always check.$t$),
    (m, 3, $t$What do the NSC diagnostic reports show?$t$,
        $j$["The names of top learners","The timetable for the exams","Common learner mistakes in each question","The school's budget"]$j$,
        2, $t$Diagnostic reports explain how learners performed and the mistakes they often made.$t$),
    (m, 4, $t$Why should learners show working in calculations?$t$,
        $j$["It makes the paper look full","Examiners do not read answers","It is only for neat handwriting","They can get marks for correct steps even if the final answer is wrong"]$j$,
        3, $t$Memos give marks for method. Showing working protects learners' marks.$t$);
end
$seed$;

------------------------------------------------------------------
-- MODULE 9
------------------------------------------------------------------
do $seed$
declare c uuid; m uuid;
begin
    select id into c from public.courses where slug = 'lesson-prep-8-12';

    insert into public.modules (course_id, position, title, summary)
    values (c, 9, $t$Supporting every teenage learner$t$,
            $t$Help learners who are behind, support learning in English across subjects, and plan for big classes, few resources and Life Orientation.$t$)
    returning id into m;

    insert into public.lessons (module_id, position, title, minutes, content_md, practice_task) values
    (m, 1, $t$Learners who are behind$t$, 10, $md$
**In this lesson** you will use AI to plan support for learners who are behind, without lowering the standard for the class.

## The gap grows over the years

Learners who fell behind in primary school often struggle more in high school, because each topic **builds on earlier ones**. In Grade 10, a learner who cannot do fractions will struggle with algebra; a learner who reads slowly will struggle with every subject.

## Find the gap

Ask the AI for **short diagnostic activities** for the skills your topic needs:

> My next Grade 10 Physical Sciences topic is "Mole concept". What prior knowledge from Grades 8 and 9 Mathematics and Natural Sciences do learners need? Give me a 10-minute diagnostic quiz to check these skills, and a 15-minute catch-up activity for each skill.

## Support inside the lesson

You cannot teach every learner separately. Plan **support inside the lesson**:

- a **worked example** on the board while others practise
- a **step-by-step card** for learners who need it
- **mixed-ability pairs**, where a stronger learner helps
- **extension questions** for fast learners

> Plan a 60-minute Grade 11 Mathematics lesson on "Analytical geometry" with: a short re-teaching part for learners who are behind, grade-level practice, and extension problems. Show what each group does and what I do.

## Describe needs without names

As always, **never** type learners' names, marks or personal situations. Write "about 10 learners" or "learners who cannot yet…".

## Know when to refer

If a learner has a serious barrier to learning or a personal problem, follow the **SIAS** process and work with the **School-Based Support Team (SBST)**. The AI cannot diagnose learners.

## Key words

| Word | Simple meaning |
|---|---|
| Catch-up activity | Short work that helps learners learn a skill they missed |
| Mixed-ability pairs | A stronger and a weaker learner working together |
| Extension | Extra, harder work for learners who finish early |

**Remember:** Find the gap, support within the lesson, and keep the standard high for everyone.
$md$,
     $t$For your next topic, ask the AI what prior knowledge learners need and for a 10-minute diagnostic quiz. Use it and plan one catch-up activity.$t$),

    (m, 2, $t$Learning subjects in English$t$, 10, $md$
**In this lesson** you will use AI to support learners whose home language is isiXhosa and who learn their subjects in English.

## Language is part of every subject

In high school, subject texts use **long sentences, technical words and academic language**. Learners may understand the concept in isiXhosa but struggle to **read the question** or **write the answer** in English.

## Teach the subject words

> I teach Grade 9 Social Sciences. The next topic is "The Cold War". List the 15 most important subject words. For each, give a simple English meaning (under 12 words) and one example sentence from the topic.

Add the **isiXhosa** term yourself or with a colleague, and build a **subject word wall**.

## Simplify texts, keep content

> Rewrite this textbook paragraph in simpler English for Grade 10 learners whose home language is isiXhosa. Keep all the subject content and terms. Use short sentences. Put the meaning of difficult words in brackets. [paste paragraph]

## Sentence starters for answers

Learners often know the answer but cannot start the sentence. Ask the AI for **sentence starters**:

> Give 10 sentence starters for learners to explain cause and effect in Geography answers (for example, "This happens because…").

## Use both languages on purpose

Let learners **discuss in isiXhosa** and **write in English**. This is called **translanguaging**. It helps learners think deeply and then express their thinking in the exam language.

## Key words

| Word | Simple meaning |
|---|---|
| Academic language | The formal language used in textbooks and exams |
| Sentence starter | The first words of a sentence, given to help learners write |
| Translanguaging | Using two languages on purpose to support learning |

**Remember:** Every subject teacher is a language teacher. Teach the words, simplify the texts, support the writing.
$md$,
     $t$Ask the AI for the 10 key subject words of your next topic and 8 sentence starters for answers. Add the isiXhosa terms yourself and put them on a wall chart.$t$),

    (m, 3, $t$Big classes, few resources and Life Orientation$t$, 10, $md$
**In this lesson** you will use AI to plan for large classes and few resources, and to prepare Life Orientation lessons.

## Big classes

Many Eastern Cape high schools have **classes of 50 to 70 learners**. Tell the AI about your situation:

> I teach Grade 8 Natural Sciences to 64 learners in a small classroom. There are textbooks for every second learner and no lab. Plan a 60-minute lesson on "Particle model of matter" with activities that work in this space, including one demonstration and one pair activity.

Ask for methods like **think–pair–share**, **numbered heads**, **gallery walks** and **quick show-me cards**.

## Prepare at home, teach offline

Many classrooms have **no internet or electricity**. Plan with AI at home on your phone, write the plan in your **file or planning book**, and teach from your notes.

## Life Orientation

**Life Orientation** covers topics such as **careers, study skills, citizenship, health, relationships and physical education**. AI can help plan discussions, scenarios and activities.

> Plan a Grade 11 Life Orientation lesson on "Study methods". Include: a short self-assessment for learners, 5 study methods with examples, a pair activity, and a simple weekly study timetable template.

## Sensitive topics need care

Topics such as **substance abuse, sexuality, gender-based violence and mental health** need great care. Use AI for **activity structures and scenarios**, but:

- check content against the **CAPS LO document and school policy**
- think about learners who may be affected personally
- know your **referral** options (SBST, social workers, clinics, helplines)

## Key words

| Word | Simple meaning |
|---|---|
| Gallery walk | Groups put work on the walls and others walk around to read it |
| Life Orientation | A subject about personal, social, career and physical development |
| Referral | Sending a learner to someone who can give special help |

**Remember:** Tell the AI your real class. Handle sensitive LO topics with care and a referral plan.
$md$,
     $t$Ask the AI for a lesson plan that fits your real class size and resources. If you teach LO, plan one lesson and list the referral options at your school.$t$);

    insert into public.quiz_questions (module_id, position, question, options, correct_index, explanation) values
    (m, 1, $t$Why do many high school learners struggle with new topics?$t$,
        $j$["The topics build on earlier skills they missed","They are too old to learn","High school content is easy","They have too many textbooks"]$j$,
        0, $t$Topics build on earlier knowledge. Finding and filling gaps helps learners cope.$t$),
    (m, 2, $t$What is a sentence starter?$t$,
        $j$["The first lesson of the year","The first words of a sentence, given to help learners write answers","A type of test","A punishment for late learners"]$j$,
        1, $t$Sentence starters help learners begin answers in English.$t$),
    (m, 3, $t$When planning a lesson on a sensitive Life Orientation topic, what is most important?$t$,
        $j$["Use the AI's content without checking","Avoid all discussion","Check content against CAPS and policy, and know your referral options","Ask learners to share private stories with the class"]$j$,
        2, $t$Sensitive topics need careful content, care for affected learners, and a referral plan.$t$),
    (m, 4, $t$How should you describe learners who are behind in your prompt?$t$,
        $j$["With their names and marks","With their ID numbers","With their home addresses","As a group need, e.g. \"about 10 learners who cannot yet…\""]$j$,
        3, $t$Describe the need, never the learner. Keep personal information private.$t$);
end
$seed$;

------------------------------------------------------------------
-- MODULE 10
------------------------------------------------------------------
do $seed$
declare c uuid; m uuid;
begin
    select id into c from public.courses where slug = 'lesson-prep-8-12';

    insert into public.modules (course_id, position, title, summary)
    values (c, 10, $t$When learners use AI, and your planning toolkit$t$,
            $t$Teach learners to use AI honestly, design assessment that shows real learning, check every plan, and build a toolkit with your subject team.$t$)
    returning id into m;

    insert into public.lessons (module_id, position, title, minutes, content_md, practice_task) values
    (m, 1, $t$Teaching learners to use AI responsibly$t$, 10, $md$
**In this lesson** you will plan how to teach your learners to use AI honestly and wisely.

## Your learners already use AI

Many high school learners use AI on their phones, for example through **WhatsApp (Meta AI)** or free chat apps. Some use it to **learn**. Some use it to **copy answers**. Banning it completely is very hard. Teaching **good use** is more effective.

## Good use and bad use

| Good use (learning) | Bad use (cheating) |
|---|---|
| Asking for a simpler explanation | Copying an AI essay and handing it in |
| Getting practice questions | Using AI during a test |
| Checking your own answer after trying | Asking for the answer without trying |
| Asking "why is my answer wrong?" | Handing in AI work as your own |

## Plan a lesson on AI use

> Plan a 45-minute Grade 10 lesson that teaches learners how to use AI chat tools responsibly for studying. Include: a discussion on good and bad use, an activity where learners compare an AI answer with their textbook to find a mistake, a short guide "5 good ways to study with AI", and the school's rules on honesty in assessment.

## Teach learners to check the AI

The most important skill: **the AI can be wrong**. Let learners **find mistakes** in AI answers. This builds critical thinking and shows them why they cannot trust it blindly.

## Follow your school's policy

Make sure what you teach matches your **school's and department's policy** on AI and academic honesty.

## Key words

| Word | Simple meaning |
|---|---|
| Academic honesty | Doing your own work and saying where ideas come from |
| Critical thinking | Thinking carefully and checking before you believe something |
| Plagiarism | Handing in someone else's work, or AI work, as your own |

**Remember:** Teach learners to use AI to learn, not to copy — and to always check it.
$md$,
     $t$Ask the AI to answer a question from your subject. Find a mistake or weakness in the answer. Use it as a class activity where learners must find the mistake.$t$),

    (m, 2, $t$Assessment that shows real learning$t$, 10, $md$
**In this lesson** you will design tasks where learners must show their **own** thinking, even if they have access to AI.

## Some tasks are easy to copy

Take-home essays and simple research tasks can be completed by AI in seconds. To see what learners really know, design tasks that **AI cannot do for them**.

## Ideas for AI-resistant tasks

- **In-class writing** — part of the task done in class under supervision
- **Process evidence** — learners hand in their plan, drafts and notes, not only the final product
- **Orals and presentations** — learners explain their work and answer questions
- **Local and personal tasks** — interviews with community members, observations of their own area
- **Reflection** — "What did you find difficult? What would you do differently?"

## Ask the AI to help redesign a task

> Here is a Grade 11 History research task. Learners could easily complete it with AI. Redesign it so learners must show their own thinking: add an in-class part, a local interview, process evidence and a short oral. Keep it within the CAPS requirements: [paste requirements]. [paste task]

## Use AI as part of the task

Sometimes you can **include AI openly**: *"Ask an AI to answer this question. Then find two mistakes in its answer, using your textbook."* This tests real understanding.

## Stay within the rules

SBA tasks must still follow **CAPS and provincial requirements**. Changes must be **fair** to all learners and ready for **moderation**.

## Key words

| Word | Simple meaning |
|---|---|
| Process evidence | Plans, drafts and notes that show how the work was done |
| Oral | A spoken assessment |
| Reflection | Thinking and writing about your own learning |

**Remember:** Design tasks where learners show their thinking — in class, in their own context, and in their own words.
$md$,
     $t$Take one take-home task you give. Ask the AI to redesign it so learners must show their own thinking. Check that it still meets the CAPS requirements.$t$),

    (m, 3, $t$Checking plans and building your toolkit$t$, 12, $md$
**In this lesson** you will use a checklist for every AI plan, and build a planning toolkit with your subject team.

## The CHECK list for high school

| Letter | Check | Question to ask yourself |
|---|---|---|
| **C** | CAPS and exam guidelines | Is the content in the ATP and examinable, at the right depth? |
| **H** | Honest facts | Are all facts, calculations, quotes and memo answers correct? |
| **E** | Easy to follow | Is the language right for my learners? |
| **C** | Cognitive levels | Is there a good spread from recall to higher-order? |
| **K** | Kit | Do I have the time, resources and equipment? |

## Fix with follow-up prompts

- *"Question 3 is outside the Grade 11 content. Replace it."*
- *"The memo for 2.4 is wrong. Recalculate and show the steps."*
- *"Add two higher-order questions."*
- *"Shorten the plan to fit 45 minutes."*

## Your high school toolkit

Save these templates in a notebook, a phone note or a shared folder:

1. **Lesson plan** — with ATP words, exam guidelines and cognitive levels
2. **Concept explanation** — with analogies and where they break down
3. **Practice set** — three levels, with memo
4. **Test with analysis grid** — with your subject's weightings
5. **Case study or context** — fictional, local, with real data you provide
6. **Past-paper style questions** — same style, new content
7. **Revision programme** — based on weak topics
8. **Fix this plan** — follow-up prompts from the CHECK list

## Work with your subject team

Share templates in **subject meetings**, **cluster meetings** and **PLCs**. Divide work: one teacher drafts revision material for a topic, another checks it. Share the **mistakes** you find in AI answers, so everyone learns.

## Key words

| Word | Simple meaning |
|---|---|
| Toolkit | Your saved set of prompts you use again and again |
| Cluster meeting | A meeting of teachers of one subject from nearby schools |
| PLC | Professional Learning Community — teachers who learn together |

**Remember:** Check every plan, save your best prompts, and share with your subject team. AI drafts, the teacher decides.
$md$,
     $t$Write at least 4 templates for your own toolkit. Test one in the Noodle Playground and improve it. Share one template with a colleague who teaches your subject.$t$);

    insert into public.quiz_questions (module_id, position, question, options, correct_index, explanation) values
    (m, 1, $t$Which of these is good use of AI by a learner?$t$,
        $j$["Copying an AI essay and handing it in","Using AI during a test","Asking AI to explain why their own answer is wrong after trying","Asking AI for the answers to homework without trying"]$j$,
        2, $t$Using AI to understand mistakes supports learning. Copying is cheating.$t$),
    (m, 2, $t$Which task is hardest for a learner to complete with AI alone?$t$,
        $j$["A take-home essay on a general topic","A list of definitions","A summary of a famous story","An in-class task with an interview of a local community member and an oral"]$j$,
        3, $t$Local, in-class and oral tasks require learners' own thinking and context.$t$),
    (m, 3, $t$In the high school CHECK list, what does the second "C" stand for?$t$,
        $j$["Cognitive levels","Colour","Copying","Class list"]$j$,
        0, $t$The second C asks whether the questions have a good spread of cognitive levels.$t$),
    (m, 4, $t$The AI's memo for one question is wrong. What is the best next step?$t$,
        $j$["Start the whole plan again","Send a follow-up prompt asking it to recalculate and show the steps, then check it","Give learners the wrong memo","Stop using memos"]$j$,
        1, $t$A follow-up prompt fixes one problem quickly — and you still check the result.$t$);
end
$seed$;
