-- Course: "AI Prompting for Teachers" (slug prompt-basics)
-- Written in plain English for teachers whose first language is not English:
-- short sentences, everyday words, every new word explained in a "Key words" box.
-- Re-running this file replaces the course (and any progress on it).

delete from public.courses where slug = 'prompt-basics';

do $seed$
declare
    c  uuid;
    m  uuid;
begin
    insert into public.courses (slug, title, summary)
    values ('prompt-basics',
            $t$AI Prompting for Teachers$t$,
            $t$A step-by-step course in simple English. Learn how to talk to AI tools so they help you plan lessons, make worksheets and tests, and write letters — while you stay in charge and keep learners safe.$t$)
    returning id into c;

    ------------------------------------------------------------------
    -- MODULE 1
    ------------------------------------------------------------------
    insert into public.modules (course_id, position, title, summary)
    values (c, 1, $t$Getting started with AI$t$,
            $t$What AI is, how it makes its answers, and what it can and cannot do for a teacher.$t$)
    returning id into m;

    insert into public.lessons (module_id, position, title, minutes, content_md, practice_task) values
    (m, 1, $t$What is AI?$t$, 8, $md$
**In this lesson** you will learn what "AI" means and why teachers are using it.

## AI in simple words

**AI** means *artificial intelligence*. It is a computer program that can do some things that usually need a human brain. For example, it can write a letter or answer a question.

In this course we talk about **AI chat tools**. You type a message. The tool types an answer back. It feels like chatting on WhatsApp.

Some AI chat tools you may know:

- ChatGPT
- Google Gemini
- Claude
- Meta AI (inside WhatsApp)
- Microsoft Copilot

They all work in a similar way. What you learn here works in all of them.

## Why should a teacher care?

Teachers have very little time. AI can help with the **first draft** of many tasks:

- a lesson plan
- a worksheet
- a letter to parents
- a test and its memo

You still check and improve the work. But you do not start from an empty page.

## Key words

| Word | Simple meaning |
|---|---|
| AI | A computer program that can write, answer and explain |
| Chat tool | A website or app where you type to the AI and it replies |
| Draft | A first try that you will check and improve |

**Remember:** AI is a helper. You are the teacher.
$md$,
     $t$Ask the AI: "Explain what AI is to a Grade 6 learner in 5 short sentences." Read the answer. Is it easy to understand?$t$),

    (m, 2, $t$How does the AI make its answers?$t$, 10, $md$
**In this lesson** you will learn how an AI chat tool "thinks". This helps you understand why it sometimes makes mistakes.

## It learned from a lot of reading

Before you use it, the AI "read" a huge amount of text: books, websites and articles. From this reading it learned how words usually fit together.

## It guesses the next words

When you ask a question, the AI writes the answer **word by word**. Each time, it chooses a word that usually comes next. It is very good at this, so the answer sounds smooth and clever.

But here is the important part: **the AI does not check facts like a person does.** It writes what *sounds* right. Usually that is also correct. Sometimes it is not.

## What the AI does not know

- It does **not** know your learners, your school or your district.
- It does **not** know what happened in your classroom today.
- It may **not** know very new news or the newest changes to CAPS.
- It only knows what **you tell it** in the chat.

This is why the way you ask matters so much. The next modules teach you how to ask well.

## Key words

| Word | Simple meaning |
|---|---|
| Trained | The AI learned from reading lots of text before you used it |
| Fact | Something that is true and can be checked |
| Mistake (error) | An answer that is wrong |

**Remember:** The AI writes what sounds right. You check what is right.
$md$,
     $t$Ask the AI: "What do you know about my school?" Read its answer. What does this tell you about what the AI knows?$t$),

    (m, 3, $t$What AI can and cannot do for you$t$, 8, $md$
**In this lesson** you will see where AI helps and where you must stay in control.

## AI is good at

- **Writing first drafts** quickly
- **Explaining one idea in many ways** — simpler, longer, with a story
- **Making many versions** — easy, medium and hard questions
- **Changing the format** — turning notes into a table or a list
- **Giving ideas** when you feel stuck

## AI is not good at

- **Always being correct.** It can make up facts, dates or numbers.
- **Knowing your class.** It cannot see your learners.
- **Making fair decisions about people.** Marks, discipline and learner wellbeing need a human.

## The golden rule

**AI drafts. The teacher decides.**

Use AI like a helpful student teacher. It works fast. It wants to help. But you must check its work before it reaches your learners.

## Key words

| Word | Simple meaning |
|---|---|
| Version | Another form of the same thing, for example an easier worksheet |
| Format | How something looks: a list, a table, a letter |
| In control | You make the final choice |

**Remember:** Use AI to save time, not to replace your judgement.
$md$,
     $t$Think of one task that takes you a long time every week. Ask the AI: "I am a teacher. Give me 3 ways you could help me with [your task]."$t$);

    insert into public.quiz_questions (module_id, position, question, options, correct_index, explanation) values
    (m, 1, $t$What is an AI chat tool?$t$,
        $j$["A program you type to, and it types an answer back","A person who answers questions online","A type of calculator","A school computer lab"]$j$,
        0, $t$You type a message and the AI types an answer back, like a chat.$t$),
    (m, 2, $t$How does the AI write its answers?$t$,
        $j$["It looks up every fact in a book","It writes word by word, choosing words that usually come next","It phones an expert","It copies your last message"]$j$,
        1, $t$The AI writes what usually comes next. That is why it can sound right but still be wrong.$t$),
    (m, 3, $t$What does the AI know about your class?$t$,
        $j$["Everything","Only what you tell it in the chat","The names of all learners","Your learners' marks"]$j$,
        1, $t$The AI cannot see your classroom. It only knows what you type.$t$),
    (m, 4, $t$What is the golden rule of this course?$t$,
        $j$["AI decides, the teacher follows","AI drafts, the teacher decides","Never use AI","Always use the first answer"]$j$,
        1, $t$AI makes a first draft. You check it and make the final decision.$t$);

    ------------------------------------------------------------------
    -- MODULE 2
    ------------------------------------------------------------------
    insert into public.modules (course_id, position, title, summary)
    values (c, 2, $t$Your first prompts$t$,
            $t$What a prompt is, how to use a chat tool, and how being clear gives better answers.$t$)
    returning id into m;

    insert into public.lessons (module_id, position, title, minutes, content_md, practice_task) values
    (m, 1, $t$What is a prompt?$t$, 8, $md$
**In this lesson** you will learn the most important word in this course: **prompt**.

## A prompt is your instruction

A **prompt** is the message you type to the AI. It tells the AI what you want.

**Prompt engineering** sounds difficult. It just means **writing good instructions** for the AI.

## Why the prompt matters

The AI does exactly what you ask. If your instruction is unclear, the answer will also be unclear.

Look at these two prompts.

**Weak prompt:** "Make a worksheet on fractions."

The AI does not know the grade, the topic inside fractions, or how many questions you want. So it guesses.

**Strong prompt:**

> Make a worksheet with 10 questions on adding fractions with the same denominator for Grade 4. Use examples about sharing oranges or bread. Add an answer key at the end.

Now the AI knows **what**, **for whom**, **how many** and **what to add**. The answer will be much more useful.

## Key words

| Word | Simple meaning |
|---|---|
| Prompt | The instruction you type to the AI |
| Prompt engineering | The skill of writing good instructions for AI |
| Answer key | The correct answers, for the teacher |

**Remember:** A clear prompt gives a clear answer.
$md$,
     $t$Make this prompt stronger: "Give me a test on the water cycle." Add the grade, the number of questions and an answer key.$t$),

    (m, 2, $t$Using a chat tool step by step$t$, 10, $md$
**In this lesson** you will learn the basic steps of using any AI chat tool.

## Step 1: Open the tool

Open the website or app, for example ChatGPT, Gemini, Claude or Meta AI in WhatsApp. Many have a free version. Some need you to sign in with an email address.

**Tip about data:** Chatting uses very little data. Making pictures or videos uses much more.

## Step 2: Start a new chat for each new task

Look for a button like **"New chat"**. Use a new chat when you change topic. The AI remembers what was said **in the same chat**, so old topics can confuse it.

## Step 3: Type your prompt and send

Type your instruction in the box at the bottom. Press **Send** (or the arrow).

## Step 4: Read the answer carefully

Read everything. Is it correct? Is it right for your learners?

## Step 5: Reply to improve it

You can keep talking. For example:

- "Make it shorter."
- "Use simpler English."
- "Add 3 more questions."

## Step 6: Copy and save

Copy the good parts into Word, Google Docs or your notebook. Then edit them yourself.

## Key words

| Word | Simple meaning |
|---|---|
| New chat | A fresh conversation where the AI forgets the old topic |
| Reply | Another message you send to change the answer |
| Edit | Change and improve text yourself |

**Remember:** One task, one chat. Read, reply, then copy.
$md$,
     $t$Ask the AI for 5 classroom rules for Grade 3. Then reply "Make them shorter and add a picture idea for each rule."$t$),

    (m, 3, $t$Be clear and specific$t$, 10, $md$
**In this lesson** you will learn a simple checklist to make any prompt clearer.

## Answer the five questions

Before you send a prompt, check that it answers these questions:

| Question | Example |
|---|---|
| **What** do I want? | A lesson plan, a worksheet, a letter |
| **For whom?** | Grade 7 learners, parents, the SMT |
| **About what topic?** | The water cycle, adjectives, area of a rectangle |
| **How long or how many?** | 10 questions, one page, 30 minutes |
| **What should it look like?** | A table, a list, with headings |

## Example

**Unclear:** "Help me with science."

**Clear:**

> Write 8 true-or-false questions about the water cycle for Grade 5 Natural Sciences. Use simple English. Put the answers at the end.

## Use simple, direct words

You do not need fancy English to write a good prompt. Short, clear sentences work best. You can even write in a mix of English and isiXhosa — but answers in English are usually more reliable.

## Key words

| Word | Simple meaning |
|---|---|
| Specific | Exact and clear, with details |
| Direct | Saying what you want plainly |
| Reliable | Can be trusted most of the time |

**Remember:** What, for whom, what topic, how many, and what it should look like.
$md$,
     $t$Write a clear prompt for a Grade 8 English reading activity. Make sure it answers all five questions.$t$);

    insert into public.quiz_questions (module_id, position, question, options, correct_index, explanation) values
    (m, 1, $t$What is a prompt?$t$,
        $j$["The answer the AI gives","The instruction you type to the AI","A type of computer","A school form"]$j$,
        1, $t$A prompt is your instruction to the AI.$t$),
    (m, 2, $t$Why should you start a new chat for a new task?$t$,
        $j$["It is faster","The AI remembers the old topic in the same chat and can get confused","New chats are free","The old chat is deleted"]$j$,
        1, $t$In one chat the AI remembers what was said, so an old topic can mix into a new task.$t$),
    (m, 3, $t$Which prompt is clearer?$t$,
        $j$["Help me with maths.","Make maths stuff.","Write 10 questions on area of rectangles for Grade 6, with answers.","Do my work."]$j$,
        2, $t$It says what, for whom, the topic, how many and what to add.$t$),
    (m, 4, $t$The answer is too long. What can you do?$t$,
        $j$["Close the tool","Reply: Make it shorter.","Start teaching anyway","Buy a new phone"]$j$,
        1, $t$You can always reply to improve the answer.$t$);

    ------------------------------------------------------------------
    -- MODULE 3
    ------------------------------------------------------------------
    insert into public.modules (course_id, position, title, summary)
    values (c, 3, $t$The RTCF recipe$t$,
            $t$A simple recipe for strong prompts: Role, Task, Context, Format — plus Constraints.$t$)
    returning id into m;

    insert into public.lessons (module_id, position, title, minutes, content_md, practice_task) values
    (m, 1, $t$R for Role: who should the AI be?$t$, 8, $md$
**In this lesson** you will learn the first part of the **RTCF** recipe: **Role**.

## The RTCF recipe

A good prompt is like a good recipe. It has four main ingredients:

| Letter | Ingredient | Question |
|---|---|---|
| **R** | Role | Who should the AI act as? |
| **T** | Task | What must it do? |
| **C** | Context | What does it need to know? |
| **F** | Format | How should the answer look? |

## Role

When you give the AI a **role**, it uses the right words and level of detail for that job.

Start your prompt with: **"You are…"**

Examples:

- "You are an experienced Foundation Phase teacher."
- "You are a friendly Mathematics teacher who explains things simply."
- "You are a school principal writing to parents."

## See the difference

Without a role, an explanation of photosynthesis may sound like a university book. With the role "You are a Grade 5 Natural Sciences teacher", it will be simpler and closer to your classroom.

## Key words

| Word | Simple meaning |
|---|---|
| Role | The job or person the AI should act as |
| Recipe | A list of steps or ingredients to make something |
| Experienced | Has done this job for a long time |

**Remember:** Start with "You are a…" to give the AI a role.
$md$,
     $t$Ask the same question twice: "Explain photosynthesis." Then: "You are a Grade 5 Natural Sciences teacher. Explain photosynthesis." Compare the two answers.$t$),

    (m, 2, $t$T and C: Task and Context$t$, 10, $md$
**In this lesson** you will learn the **Task** and **Context** parts of the recipe.

## Task: what exactly must the AI do?

Use an **action word** at the start: *write, make, explain, list, summarise, translate, check.*

- "**Write** a 30-minute lesson plan on telling the time."
- "**Make** 10 multiple-choice questions on the solar system."
- "**Summarise** these meeting notes."

## Context: what does the AI need to know?

**Context** means the background information. Remember: the AI cannot see your classroom. You must describe it.

Useful context for teachers:

- grade and subject
- CAPS term and topic
- number of learners
- learners' home language
- resources you have (or do not have) — chalkboard, no projector, no printer
- what learners already know

## Put Role, Task and Context together

> You are an experienced Foundation Phase teacher. Write a 30-minute lesson plan on telling the time to the hour for Grade 2. The class has 45 learners whose home language is isiXhosa. We have only one wall clock and a chalkboard.

## Key words

| Word | Simple meaning |
|---|---|
| Task | The job you want the AI to do |
| Action word | A word that says what to do, like "write" or "list" |
| Context | Background information about your situation |

**Remember:** You know your class. Tell the AI about it.
$md$,
     $t$Write a prompt with a Role, a Task and rich Context for a Grade 9 lesson in your subject. Include class size and resources.$t$),

    (m, 3, $t$F and C: Format and Constraints$t$, 10, $md$
**In this lesson** you will learn how to control **how the answer looks** and **what limits it must keep**.

## Format: how should the answer look?

Tell the AI the shape of the answer:

- "Use headings: Aim, Resources, Introduction, Activity, Assessment."
- "Put it in a table with 3 columns."
- "Write it as a numbered list."
- "Write it as a letter."

## Constraints: what are the limits?

A **constraint** is a limit or rule. Constraints make the answer fit real life.

- **Length:** "Keep it under one page." "Exactly 5 questions."
- **Time:** "The activity must take 20 minutes."
- **Resources:** "No printing." "No electricity needed."
- **Language:** "Use simple English for second-language learners."

## The full recipe: RTCF + Constraints

> **Role:** You are a Grade 6 Social Sciences teacher.
> **Task:** Write a lesson plan on the map of South Africa's provinces.
> **Context:** 50 learners, home language isiXhosa, one wall map, no projector.
> **Format:** Use headings: Aim, Resources, Introduction, Activity, Assessment.
> **Constraints:** 45 minutes. No printing. Simple English.

You do not have to write the labels (Role:, Task:). They just help you remember.

## Key words

| Word | Simple meaning |
|---|---|
| Format | The shape of the answer: table, list, letter |
| Constraint | A limit or rule the answer must follow |
| Heading | A short title for a part of the text |

**Remember:** R-T-C-F + Constraints = a strong prompt.
$md$,
     $t$Use the full recipe (Role, Task, Context, Format, Constraints) to ask for a 40-minute Grade 9 Natural Sciences lesson on the digestive system for 50 learners with no projector.$t$);

    insert into public.quiz_questions (module_id, position, question, options, correct_index, explanation) values
    (m, 1, $t$In RTCF, what does R stand for?$t$,
        $j$["Read","Role","Rule","Repeat"]$j$,
        1, $t$Role: who the AI should act as, for example "You are a Grade 4 teacher".$t$),
    (m, 2, $t$"My class has 48 learners and no projector" is an example of…$t$,
        $j$["Role","Task","Context","Format"]$j$,
        2, $t$It is background information about your situation — Context.$t$),
    (m, 3, $t$"Put the answer in a table" is an example of…$t$,
        $j$["Format","Role","Context","Task"]$j$,
        0, $t$It tells the AI how the answer should look — Format.$t$),
    (m, 4, $t$"The activity must take only 20 minutes and need no printing" is a…$t$,
        $j$["Role","Constraint","Mistake","Heading"]$j$,
        1, $t$A constraint is a limit the answer must follow.$t$);

    ------------------------------------------------------------------
    -- MODULE 4
    ------------------------------------------------------------------
    insert into public.modules (course_id, position, title, summary)
    values (c, 4, $t$Showing and guiding the AI$t$,
            $t$Three powerful tricks: give examples, ask for steps, and let the AI ask you questions.$t$)
    returning id into m;

    insert into public.lessons (module_id, position, title, minutes, content_md, practice_task) values
    (m, 1, $t$Show an example$t$, 10, $md$
**In this lesson** you will learn to **show** the AI what you want by giving an example.

## Showing is often better than telling

Sometimes it is hard to describe the style you want. It is easier to **show one example**. The AI will copy the style.

Experts call this **few-shot prompting**. "Shot" here just means "example".

## Example

> Here is an example of the kind of question I want:
> "Sipho has R50. He buys 2 loaves of bread at R18 each. How much change does he get? (2 marks)"
> Write 5 more questions in the same style about buying things at a spaza shop. Use different names and amounts.

The AI will now write short money problems, with local names, prices in rand and marks at the end — just like your example.

## When to use examples

- When you want a special **style** of question
- When you want a special **layout**
- When you want a certain **level** of difficulty

## Tip

One good example is often enough. Two or three examples are even better if the task is difficult.

## Key words

| Word | Simple meaning |
|---|---|
| Example | One sample that shows what you mean |
| Style | The way something is written |
| Few-shot prompting | Giving the AI a few examples to copy |

**Remember:** If it is hard to explain, show an example.
$md$,
     $t$Write one example question in your subject. Then ask the AI to write 5 more questions in the same style.$t$),

    (m, 2, $t$Ask for steps$t$, 10, $md$
**In this lesson** you will learn to ask the AI to **work step by step**.

## Why steps help

For maths problems, planning and difficult questions, the AI makes fewer mistakes when it works **one step at a time**. Steps also make it easier for **you** to check the work.

## Simple ways to ask for steps

- "Solve this **step by step**."
- "Show your working."
- "First list the steps. Then do each step."
- "Explain your thinking in simple steps."

## Example for Mathematics

> Solve this step by step, the way a Grade 7 learner should write it: A taxi carries 15 passengers. How many taxis are needed for 112 learners going on a school trip?

Now check: did the AI round **up** to 8 taxis? A good teacher knows you cannot use 7.46 taxis!

## Example for planning

> I need to teach fractions in Term 2 over 3 weeks. First list the steps I should follow to plan this. Then give me a plan for week 1 only.

Breaking a big job into **small steps** gives better results than asking for everything at once.

## Key words

| Word | Simple meaning |
|---|---|
| Step by step | One small part at a time, in order |
| Working | The steps used to get an answer in maths |
| Break down | Divide a big job into smaller jobs |

**Remember:** Big job? Ask for small steps.
$md$,
     $t$Give the AI a word problem from your subject and ask it to solve it step by step for a Grade 7 learner. Check every step.$t$),

    (m, 3, $t$Let the AI ask you questions$t$, 10, $md$
**In this lesson** you will learn two clever tricks: let the AI **ask you questions**, and let the AI **improve your prompt**.

## Trick 1: "Ask me questions first"

Sometimes you do not know what information to give. Let the AI ask you!

> I want a lesson plan for Grade 4 English on describing words. Before you write it, ask me up to 5 questions about my class. Wait for my answers.

The AI will ask things like: How many learners? How long is the lesson? What resources do you have? You answer. Then it writes a plan that fits your class.

## Trick 2: "Improve my prompt"

You can ask the AI to help you write a better prompt.

> I want to use AI to make a Grade 10 Life Sciences revision worksheet. Here is my prompt: "make revision for cells". Please improve my prompt and explain what you added.

Read what it added. You will learn what makes a strong prompt — and you get a better worksheet.

## Key words

| Word | Simple meaning |
|---|---|
| Information | Facts or details |
| Improve | Make better |
| Revision | Going over work again before a test |

**Remember:** Not sure what to say? Ask the AI to ask you.
$md$,
     $t$Ask the AI: "Before you write a Grade 5 lesson plan on healthy eating, ask me 5 questions about my class." Answer the questions and see the plan.$t$);

    insert into public.quiz_questions (module_id, position, question, options, correct_index, explanation) values
    (m, 1, $t$Giving the AI one sample question so it copies the style is called…$t$,
        $j$["Few-shot prompting","Typing","Translation","Guessing"]$j$,
        0, $t$Few-shot prompting means giving a few examples.$t$),
    (m, 2, $t$Why ask the AI to work "step by step"?$t$,
        $j$["It makes fewer mistakes and you can check each step","It uses more data","It is required by law","It makes the answer funny"]$j$,
        0, $t$Steps help the AI and make checking easy for you.$t$),
    (m, 3, $t$You are not sure what details to give. What can you do?$t$,
        $j$["Give up","Ask the AI to ask you questions first","Type random words","Use a calculator"]$j$,
        1, $t$Let the AI ask you questions, then it can fit the answer to your class.$t$),
    (m, 4, $t$A big job (like a term plan) is best done…$t$,
        $j$["In one very long prompt","In small steps","Without AI ever","By copying a friend"]$j$,
        1, $t$Break big jobs into smaller steps.$t$);

    ------------------------------------------------------------------
    -- MODULE 5
    ------------------------------------------------------------------
    insert into public.modules (course_id, position, title, summary)
    values (c, 5, $t$Improving and checking answers$t$,
            $t$Talk back to the AI, spot its mistakes, and check facts before you use anything.$t$)
    returning id into m;

    insert into public.lessons (module_id, position, title, minutes, content_md, practice_task) values
    (m, 1, $t$The first answer is only a draft$t$, 10, $md$
**In this lesson** you will learn to **talk back** to the AI to get a better answer.

## Do not stop at the first answer

People who use AI well almost never use the first answer. They **reply** and ask for changes. This is normal and quick.

## Useful follow-up messages

Copy these and use them any time:

- "Make it shorter — one page only."
- "Use simpler English for second-language learners."
- "Change the examples to things learners in the Eastern Cape know."
- "Add 3 harder questions at the end."
- "Put this in a table."
- "Give me two other options."
- "What did you assume about my class?"

## Example conversation

1. You: *Write a short poem about rain for Grade 3.*
2. AI writes a poem with difficult words.
3. You: *Use only words a Grade 3 second-language learner knows. Make it 8 lines.*
4. AI writes a simpler poem.
5. You: *Add actions learners can do with each line.*

Three short messages — and now you have a poem **and** an activity.

## Key words

| Word | Simple meaning |
|---|---|
| Follow-up | A message that continues the conversation |
| Option | A choice |
| Assume | To think something is true without checking |

**Remember:** Reply, reply, reply — until it fits your class.
$md$,
     $t$Ask for "a poem about rain for Grade 3". Then improve it with at least two follow-up messages.$t$),

    (m, 2, $t$When AI gets it wrong$t$, 10, $md$
**In this lesson** you will learn about the biggest danger of AI: **confident mistakes**.

## AI can "make things up"

Sometimes the AI writes things that are **not true**, but it sounds very sure. Experts call this **hallucination**. It means the AI "imagined" something.

Examples of mistakes AI can make:

- wrong dates in history
- wrong answers in maths, especially long calculations
- books, websites or quotes that **do not exist**
- wrong CAPS topics for a grade or term
- wrong or strange translations into isiXhosa

## How to catch mistakes

| Check | How |
|---|---|
| Facts and dates | Check in the textbook or a trusted website |
| Maths | Work out the answer yourself, or use a calculator |
| CAPS | Compare with your CAPS document or ATP |
| Translations | Ask a fluent colleague to read it |
| Sources | Search for the book or website. Does it really exist? |

## Be extra careful with

- memos and answer keys
- anything you will give to learners
- anything about health, law or money

## Key words

| Word | Simple meaning |
|---|---|
| Hallucination | When AI writes something false as if it is true |
| Confident | Sounding very sure |
| Source | Where information comes from, like a book |

**Remember:** Sounds right is not the same as is right. Check.
$md$,
     $t$Ask the AI: "Give me 3 books about the history of the Eastern Cape with their authors." Then search for each book. Do they really exist?$t$),

    (m, 3, $t$Ask the AI to check itself$t$, 8, $md$
**In this lesson** you will learn quick ways to make the AI **check its own work**.

## The AI can find some of its own mistakes

After the AI gives an answer, send a follow-up like:

> Check your answer for mistakes. Look at the facts, the maths and whether it fits Grade 6 CAPS. List any problems, then give a corrected version.

The AI will often find errors it made. This does **not** replace your own check — but it catches many problems quickly.

## Other checking prompts

- "Which parts of your answer are you not sure about?"
- "Show me the working for question 4."
- "Is this answer correct for Grade 9, or is it too hard?"
- "Read this as a strict subject advisor. What would you change?"

## Compare two answers

Another trick: open a **new chat** and ask the same question again. If the two answers are very different, be careful — check the facts yourself.

## Key words

| Word | Simple meaning |
|---|---|
| Correct (verb) | Fix a mistake |
| Corrected version | The new answer with the mistakes fixed |
| Subject advisor | A department official who supports teachers in a subject |

**Remember:** Ask the AI to check — then check it yourself too.
$md$,
     $t$Ask the AI for a 5-question Grade 7 Maths quiz with a memo. Then ask: "Check your memo for mistakes and show the working." Did it find anything?$t$);

    insert into public.quiz_questions (module_id, position, question, options, correct_index, explanation) values
    (m, 1, $t$The AI's first answer is too difficult for your learners. What should you do?$t$,
        $j$["Use it anyway","Reply: Use simpler English for second-language learners.","Delete the app","Give it to the learners to fix"]$j$,
        1, $t$Reply with a follow-up to improve the answer.$t$),
    (m, 2, $t$What is an AI "hallucination"?$t$,
        $j$["When the AI is slow","When the AI writes something false as if it is true","When the AI makes a picture","When the internet is off"]$j$,
        1, $t$A hallucination is a confident answer that is not true.$t$),
    (m, 3, $t$How should you check an isiXhosa translation from AI?$t$,
        $j$["Trust it fully","Ask a fluent colleague to read it","Translate it into French","Do not check it"]$j$,
        1, $t$AI translations can be wrong. A fluent person should check.$t$),
    (m, 4, $t$Asking the AI to check its own answer…$t$,
        $j$["Replaces your own check","Helps find mistakes, but you must still check","Is not allowed","Always makes it worse"]$j$,
        1, $t$It helps, but the teacher still checks.$t$);

    ------------------------------------------------------------------
    -- MODULE 6
    ------------------------------------------------------------------
    insert into public.modules (course_id, position, title, summary)
    values (c, 6, $t$AI for planning and teaching$t$,
            $t$Use AI to plan CAPS lessons, make activities for different levels, and explain ideas simply.$t$)
    returning id into m;

    insert into public.lessons (module_id, position, title, minutes, content_md, practice_task) values
    (m, 1, $t$Planning a CAPS lesson$t$, 12, $md$
**In this lesson** you will use AI to draft a lesson plan that matches **CAPS**.

## Give the exact CAPS details

The AI knows *about* CAPS, but it can mix up grades and terms. Give it the details from **your own documents**:

- subject, grade, term and week
- the topic **in the same words** as your ATP or CAPS document
- the lesson length
- what assessment you need

## Example prompt

> You are a Grade 6 Social Sciences teacher in the Eastern Cape. Using CAPS Term 3 History, topic "Democracy and citizenship in South Africa", write a 45-minute lesson plan. My learners are second-language English speakers and there are 52 of them. Include one pair activity with no printing, and 3 oral questions to check understanding. Use headings: Aim, Resources, Introduction, Activity, Conclusion, Assessment.

## Check the plan with 4 questions

1. **Correct?** Are the facts right?
2. **CAPS?** Does it match your ATP topic and skills?
3. **Real?** Does it fit your time, class size and resources?
4. **Fair and local?** Will your learners understand the examples?

If the answer to any question is "no", **reply** and ask the AI to fix it.

## Key words

| Word | Simple meaning |
|---|---|
| CAPS | The national curriculum document for each subject |
| ATP | Annual Teaching Plan: what to teach each week |
| Assessment | Checking what learners have learned |

**Remember:** Copy the exact topic words from your ATP into the prompt.
$md$,
     $t$Take a topic from your own ATP for next week. Write a full RTCF prompt for a lesson plan. Then check the plan with the 4 questions.$t$),

    (m, 2, $t$One class, many levels$t$, 10, $md$
**In this lesson** you will use AI to make **different versions** of an activity for learners at different levels.

## Why this helps

In a big class, some learners need more help and some finish early. Making three versions by hand takes a long time. AI can do it in seconds.

Teachers call this **differentiation**: changing the work so every learner can learn.

## Example prompt

> Make the same activity on equivalent fractions at three levels for Grade 5:
> 1. Support — for learners still learning halves and quarters
> 2. Core — normal Grade 5 CAPS level
> 3. Extension — for learners who finish early
> Give 5 questions for each level and an answer key.

## Other ideas

- the same reading passage at **two reading levels**
- **easier words** for a worksheet, with the same questions
- **extra help** steps for learners who struggle
- a **challenge question** for strong learners

## Key words

| Word | Simple meaning |
|---|---|
| Level | How easy or hard the work is |
| Differentiation | Changing work so all learners can learn |
| Support | Extra help |
| Extension | Extra challenge for learners who finish early |

**Remember:** Ask for "three levels: support, core and extension".
$md$,
     $t$Ask for a short reading passage about the Wild Coast with questions at three levels: support, core and extension.$t$),

    (m, 3, $t$Explaining ideas in simple ways$t$, 10, $md$
**In this lesson** you will use AI to find **new ways to explain** a difficult idea.

## Many ways to explain

When learners do not understand, try a different explanation. Ask the AI for:

- an **everyday example** from home or the community
- a **short story**
- a **picture idea** to draw on the chalkboard
- a **simple comparison**: "it is like…"
- **simpler words**

## Example prompt

> Explain "evaporation" to Grade 4 learners in three ways:
> (a) an everyday example from a rural home,
> (b) a short story with a learner named Lwazi,
> (c) a simple drawing I can make on the chalkboard.
> Use very simple English.

## Home language support

You can ask the AI to explain in **isiXhosa** or another language. This can help learners who are still learning English.

**But be careful:** AI is weaker in isiXhosa than in English. Words can be wrong or sound strange. Always ask a fluent colleague to check before you use it with learners.

## Key words

| Word | Simple meaning |
|---|---|
| Explanation | Words that help someone understand |
| Comparison | Showing how two things are alike |
| Fluent | Speaks a language very well |

**Remember:** If learners do not understand, ask the AI for another way to explain.
$md$,
     $t$Choose a difficult idea from your subject. Ask the AI to explain it in three different ways for your grade.$t$);

    insert into public.quiz_questions (module_id, position, question, options, correct_index, explanation) values
    (m, 1, $t$What is the best way to help the AI match CAPS?$t$,
        $j$["Say only: make it CAPS","Copy the exact topic words, grade and term from your ATP","Let the AI guess the grade","Write one word"]$j$,
        1, $t$Exact details from your ATP reduce mistakes.$t$),
    (m, 2, $t$What does "differentiation" mean?$t$,
        $j$["Giving every learner the same work","Changing work so learners at different levels can all learn","Marking tests","Translating work"]$j$,
        1, $t$Differentiation means adjusting work for different levels.$t$),
    (m, 3, $t$An "extension" activity is for…$t$,
        $j$["Learners who finish early and need a challenge","Learners who were absent","Parents","The principal"]$j$,
        0, $t$Extension work gives a challenge to strong learners.$t$),
    (m, 4, $t$Before you use an AI explanation in isiXhosa, you should…$t$,
        $j$["Use it right away","Ask a fluent colleague to check it","Print 100 copies","Translate it to English and back"]$j$,
        1, $t$AI can make mistakes in isiXhosa. A fluent speaker should check.$t$);

    ------------------------------------------------------------------
    -- MODULE 7
    ------------------------------------------------------------------
    insert into public.modules (course_id, position, title, summary)
    values (c, 7, $t$AI for assessment and admin$t$,
            $t$Make questions, memos and rubrics, give feedback safely, and write letters and minutes.$t$)
    returning id into m;

    insert into public.lessons (module_id, position, title, minutes, content_md, practice_task) values
    (m, 1, $t$Making tests and memos$t$, 12, $md$
**In this lesson** you will use AI to make a **test** with a **memo**.

## Tell the AI how to build the test

Give these details:

- grade, subject and topic
- total marks
- types of questions (multiple choice, short answer, long answer)
- **cognitive levels** — how much thinking each question needs
- that you want a **memo** with marks

## Cognitive levels in simple words

| Level | Learners must… | Example word in the question |
|---|---|---|
| Low | remember | name, list, define |
| Middle | use what they know | calculate, explain, compare |
| High | solve new problems | solve, design, evaluate |

## Example prompt

> You are a Grade 8 Mathematics teacher. Make a 20-mark test on algebraic expressions.
> Use: 30% low level, 50% middle level, 20% high level questions.
> Show the marks next to each question.
> Then give a full memo with the working and method marks.

## Always check the memo

AI often makes small mistakes in memos. **Work out every answer yourself** before you mark with it.

## Key words

| Word | Simple meaning |
|---|---|
| Memo | The marking guideline with correct answers |
| Cognitive level | How much thinking a question needs |
| Method marks | Marks for correct steps, even if the final answer is wrong |

**Remember:** AI can write the test fast. You must check the memo.
$md$,
     $t$Ask for a 10-mark Grade 7 Natural Sciences quiz on mixtures with a memo. Ask for low, middle and high level questions. Check every answer in the memo.$t$),

    (m, 2, $t$Rubrics and feedback$t$, 10, $md$
**In this lesson** you will use AI to make **rubrics** and to help write **feedback** — safely.

## Rubrics

A **rubric** is a table that shows what a learner must do to get each mark.

> Make a 4-level rubric (Not achieved, Partly achieved, Achieved, Excellent) for a Grade 10 English FAL descriptive essay. Criteria: ideas, structure, language, spelling and punctuation. Total 30 marks. Use simple words learners can understand.

You can share the rubric with learners **before** they write. Then they know what is expected.

## Feedback on learner work — keep it anonymous

You can ask AI to help you write kind and useful feedback. But **never** include the learner's name or personal details. Type or paste only the work itself.

> Here is a paragraph written by a Grade 9 learner (no name). Give 2 things done well and 2 clear next steps. Use kind, simple English that a 14-year-old understands: "…"

**You** decide the mark. The AI only helps with the words.

## Key words

| Word | Simple meaning |
|---|---|
| Rubric | A marking table that explains each level |
| Criteria | The things you will mark, like spelling or ideas |
| Anonymous | Without a name, so no one knows who it is |
| Feedback | Comments that help a learner improve |

**Remember:** Remove names first. The teacher gives the mark.
$md$,
     $t$Ask for a 4-level rubric for a Grade 5 oral presentation called "My community hero".$t$),

    (m, 3, $t$Letters, notices and minutes$t$, 10, $md$
**In this lesson** you will use AI for **school admin**: letters, notices and meeting minutes.

## Letters to parents

> Write a short, friendly letter to parents of Grade 7 learners about the Natural Sciences project. Due date: 15 March. Materials: only recycled items like bottles and boxes. Explain how parents can help at home. Keep it under 150 words. Use simple English.

You can then ask: "Now write the same letter in isiXhosa." — and ask a fluent colleague to check it.

## Short SMS or WhatsApp messages

> Write a WhatsApp message (under 50 words) reminding parents that sports day is on Friday and learners must bring water and a hat.

## Meeting minutes

> Here are my rough notes from our phase meeting (no names). Turn them into formal minutes with these headings: Attendance (number only), Matters discussed, Decisions, Action items (role and date).

## Check before you send

Read every message as if **you** are the parent. Is it polite? Is the date right? Is anything missing?

## Key words

| Word | Simple meaning |
|---|---|
| Admin | Office work, like letters and forms |
| Notice | A short message to tell people about something |
| Minutes | The written record of a meeting |

**Remember:** AI writes the draft. You check every date, name and detail.
$md$,
     $t$Ask for a short bilingual (English and isiXhosa) WhatsApp reminder to parents about a school sports day. Plan who will check the isiXhosa.$t$);

    insert into public.quiz_questions (module_id, position, question, options, correct_index, explanation) values
    (m, 1, $t$What is a memo?$t$,
        $j$["A letter to parents","The marking guideline with the correct answers","A type of test","A meeting"]$j$,
        1, $t$A memo gives the correct answers and marks.$t$),
    (m, 2, $t$"Calculate" and "explain" are words for which cognitive level?$t$,
        $j$["Low","Middle","High","None"]$j$,
        1, $t$Middle level questions ask learners to use what they know.$t$),
    (m, 3, $t$Before you ask AI for feedback on learner work, you must…$t$,
        $j$["Add the learner's full name","Remove names and personal details","Add the learner's ID number","Upload the class list"]$j$,
        1, $t$Keep learner work anonymous to protect learners.$t$),
    (m, 4, $t$Who decides the final mark?$t$,
        $j$["The AI","The learner","The teacher","The parent"]$j$,
        2, $t$Marks are always the teacher's decision.$t$);

    ------------------------------------------------------------------
    -- MODULE 8
    ------------------------------------------------------------------
    insert into public.modules (course_id, position, title, summary)
    values (c, 8, $t$Safe, fair use and your prompt toolkit$t$,
            $t$Protect learners' privacy, use AI fairly and honestly, and build your own set of ready-made prompts.$t$)
    returning id into m;

    insert into public.lessons (module_id, position, title, minutes, content_md, practice_task) values
    (m, 1, $t$Keeping learners safe: privacy and POPIA$t$, 10, $md$
**In this lesson** you will learn what information you must **never** type into an AI tool.

## Why privacy matters

When you type into an AI tool, your words go to a company's computers. You do not control what happens to them. In South Africa, the law called **POPIA** protects people's personal information. Learners are children, so we must be extra careful.

## Never type these into AI

- learners' **full names**
- **ID numbers** or birth dates
- **marks** linked to a name
- **health** information or disabilities
- **family** problems or home situations
- **photos** of learners
- addresses or phone numbers

## What you can do instead

- Use **no name**: "a Grade 6 learner".
- Use a **made-up name**: "a learner called Learner A".
- Remove details before you paste any work.

**Safe:** "A Grade 8 learner wrote this paragraph. Give feedback: …"

**Not safe:** "Thandiwe Mbeki, ID 1203…, got 23% and her mother is sick. Write a report."

## Key words

| Word | Simple meaning |
|---|---|
| Privacy | Keeping personal information safe |
| POPIA | Protection of Personal Information Act — a South African law |
| Personal information | Details about a real person, like name or ID number |

**Remember:** No names, no ID numbers, no marks with names. Ever.
$md$,
     $t$Rewrite this unsafe prompt to make it safe: "Write a report for Sipho Dlamini in Grade 5 who failed Maths with 28% because his father lost his job."$t$),

    (m, 2, $t$Using AI fairly and honestly$t$, 10, $md$
**In this lesson** you will think about **fairness, honesty** and **learners using AI**.

## Watch for bias

AI learned from text written mostly in other countries. So it can show **bias** — unfair ideas about people, cultures, genders or abilities. It may also use examples that do not fit South African learners, like snow or American money.

Ask yourself: **Is this fair to all my learners? Will they see themselves in it?** If not, ask the AI to change it.

> Change the examples so they fit learners in a rural Eastern Cape school, and include both boys and girls in leading roles.

## Be honest

Follow your school and the Department's rules about using AI. Do not pretend AI work is fully your own if your school asks you to say when you used AI.

## Learners and AI

Learners will use AI too. Teach them:

- AI can be **wrong**, so they must check.
- Copying AI is **not learning**.
- Their **own thinking** matters most.

Design tasks that need learners' own thinking: oral answers, work about their own community, or reflection on their own experience.

## Key words

| Word | Simple meaning |
|---|---|
| Bias | Unfair ideas that favour or harm some people |
| Fair | Treating everyone in the right and equal way |
| Reflection | Thinking about your own experience and learning |

**Remember:** Check that AI work is fair, local and honest.
$md$,
     $t$Ask the AI for a short Grade 4 story about a learner who becomes a scientist. Read it: is it fair and local? Ask the AI to improve anything that is not.$t$),

    (m, 3, $t$Build your own prompt toolkit$t$, 12, $md$
**In this lesson** you will build a **prompt toolkit**: a set of ready-made prompts you can use again and again.

## What is a prompt template?

A **template** is a prompt with **blank spaces** that you fill in each time. You write it once and save time forever.

## Template 1: Lesson plan

> You are an experienced [subject] teacher in the Eastern Cape. Write a [length]-minute lesson plan for Grade [grade] on "[topic from ATP]", CAPS Term [term]. The class has [number] learners whose home language is [language]. Resources: [resources]. Use headings: Aim, Resources, Introduction, Activity, Conclusion, Assessment. Use simple English.

## Template 2: Worksheet at three levels

> Make a worksheet on [topic] for Grade [grade] at three levels: support, core and extension. Give [number] questions per level and an answer key. Use local examples learners in the Eastern Cape know.

## Template 3: Letter to parents

> Write a short, friendly letter to parents of Grade [grade] learners about [event]. Include [date], [what learners need] and [how parents can help]. Under 150 words. Simple English.

## Save your toolkit

Keep your templates in a notebook, a Word document or a WhatsApp chat with yourself. Share good ones with colleagues in your phase or subject.

## Well done!

You have finished the course. You can now write clear prompts, guide the AI, check its answers and use it safely. Keep practising in the **Playground** — every prompt makes you better.

## Key words

| Word | Simple meaning |
|---|---|
| Template | A ready-made prompt with blanks to fill in |
| Toolkit | A set of tools you keep for your work |
| Reuse | Use again |

**Remember:** Write a good prompt once, save it, and use it many times.
$md$,
     $t$Write your own prompt template for a task you do every week. Test it in the Playground by filling in the blanks.$t$);

    insert into public.quiz_questions (module_id, position, question, options, correct_index, explanation) values
    (m, 1, $t$Which law protects personal information in South Africa?$t$,
        $j$["POPIA","The Traffic Act","The Labour Relations Act","No law"]$j$,
        0, $t$POPIA: the Protection of Personal Information Act.$t$),
    (m, 2, $t$Which of these is SAFE to type into an AI tool?$t$,
        $j$["A learner's full name and marks","A learner's ID number","A paragraph written by a learner, with no name","A photo of the class"]$j$,
        2, $t$Anonymous work with no personal details is safe.$t$),
    (m, 3, $t$The AI uses snow and US dollars in a story for your learners. This is an example of…$t$,
        $j$["Examples that do not fit your learners — ask the AI to change them","A perfect answer","Privacy","A memo"]$j$,
        0, $t$Ask the AI to use local examples your learners know.$t$),
    (m, 4, $t$What is a prompt template?$t$,
        $j$["A ready-made prompt with blanks you fill in each time","A type of computer","A test memo","A school rule"]$j$,
        0, $t$Templates save time because you reuse them.$t$);
end
$seed$;
