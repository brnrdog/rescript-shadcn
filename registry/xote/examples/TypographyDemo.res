@xote.component
let make = () =>
  <div class="w-full max-w-2xl">
    <h1 class="scroll-m-20 text-4xl font-extrabold tracking-tight text-balance">
      {"The Joke Tax Chronicles"}
    </h1>
    <p class="text-muted-foreground mt-4 text-xl">
      {"A king decreed that anyone who tells a joke must pay a tax."}
    </p>
    <h2 class="mt-8 scroll-m-20 border-b pb-2 text-3xl font-semibold tracking-tight">
      {"The King's Plan"}
    </h2>
    <p class="mt-4 leading-7">
      {"The king thought long and hard, and finally came up with a brilliant plan: he would tax the jokes in the kingdom."}
    </p>
    <blockquote class="mt-6 border-l-2 pl-6 italic">
      {"\"After all,\" he said, \"everyone enjoys a good joke, so it is only fair that they should pay for the privilege.\""}
    </blockquote>
    <ul class="my-6 ml-6 list-disc [&>li]:mt-2">
      <li> {"1st level of puns: 5 gold coins"} </li>
      <li> {"2nd level of jokes: 10 gold coins"} </li>
      <li> {"3rd level of one-liners: 20 gold coins"} </li>
    </ul>
    <p class="mt-4 leading-7">
      {"The people of the kingdom, feeling upset, "}
      <code class="bg-muted relative rounded px-[0.3rem] py-[0.2rem] font-mono text-sm font-semibold">
        {"revolted"}
      </code>
      {" against the tax."}
    </p>
  </div>
