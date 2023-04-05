# Exchanging R-snippets through the MS Teams channel

I teach students how to use R for statistics and data analysis, but what I would like to do is to inspire them to use technology smartly. One way to do so is to automate some boring staff. Here is how I automated R exercises using MS Teams and R.

I send them simple tasks through a MS Teams chat channel. They write the code in the form of R function, test the function on their machines and send it back through the channel to the whole class. Now, all of us can see, discuss and verify these snippets.

Since there might be hundreds of snippets, I have to automate process of collecting, parsing, storing and evaluating them. Package "Microsoft365R" enables us to connect Teams and R, that is to receive and send messages from R. For all the tasks, there are examples of functions' input and output that can be tested automatically. That way, machine can provide students with the instant feedback. They know if they solved the problem while the exercise still goes on.  
