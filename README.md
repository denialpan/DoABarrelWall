# DoABarrelWall
Cycle through lockscreen and homescreen wallpapers with an "unlimited" set amount of images. Similar idea that Android has.

## Contributors
Because these people are more important than the tweak itself.

### Table Of Contents
- Prologue
- Current Thoughts
- Credits
- Conclusion

#### Prologue

I find the Jailbreak community to be a strange place. It encapsulates much of how the rest of the world works and interacts with each other, in its own place of a microcosm, and I think that it's important to acknowledge this. In such a diverse community, there will always be a conflict of ideas and beliefs in what methods are morally right and which are frowned upon, especially more in a somewhat unregulated marketplace. This is, as the rest of the world functions in nearly the same way, nothing special. But given my time here, it has shed some light on situations I didn't notice in the beginning.

The Jailbreak community has the same people that exist in nearly every online community that surrounds themselves on a usable product. In this case, these are generally the people I have noticed after some years.

- **Newcomers:** Those interested in what the community has to offer and usually start off asking basic questions.
- **Active Users:** Those that spend some time every day in the community to see what's new and to help others when they can.
- **Developers:** Those that provide a service for the community, most likely tweaks, or a solution to an ongoing problem.
- **Piraters:** Those that are unable to pay for the tweaks provided by developers, either by choice or impossible for them to.

Before I started this project, I identified myself with three out of the four above at some point, with the last one being a very prominent one. I could have easily purchased the tweaks myself, but due to a lack of empathy and not fully understanding the process needed to create something of value, I disregarded the money as being far too expensive for something that did so little on a device.

I find myself fortunate that I was able to encounter a developer that open sourced their work heavily on Github. After sifting through their many repositories and reading through the code, I understood that tweak development is a skill in it by itself; it is almost like stabbing in the dark. Setting up the proper environment is simple enough, but when it comes to getting started on an idea, it is slightly difficult to make sense of anything with a majority of the resources consisting of the official [Apple Documentation](https://developer.apple.com/documentation/), a community-driven [wiki page](https://iphonedevwiki.net/index.php/Main_Page), this [header page](https://developer.limneos.net/) that provides nearly every single class dump of headers available to modify, and whatever up-to-date open source projects you can find. These resources are by far sufficient enough to create something, but without the understanding of how everything is pieced together, it can be overwhelming even for those with prior programming experience, and this was the state I was when I first examined a tweak's source code.

I have since permanently removed every single illegitimate copy of every tweak off my device in August of 2020 after realizing that tweak development isn't as simple as it is, and my mediocre opinion for tweak developers have been replaced with newfound respect. At this point I still haven't given tweak development a try myself, with the reasons aforementioned of believing it requires unbelievable amount of skill to become one, but I stayed long enough in the community to slowly understand what makes a tweak run, the processes behind, and the fundamentals of how they are constructed. 

As the days went on, I was able to witness a beginner, like me, that initially didn't know anything tweak development, a few weeks later create a tweak that was simple enough of implementing dark mode for apps that I use that didn't natively support it. This was by far enough encouragement and reason for me to finally give tweak development a try, but the only problem that I truly had was a lack of ideas to make anything unique. So, for months, I let the idea of tweak development just sit in my mind.

#### Current Thoughts

A tweak is only as good as the idea itself. No matter how good a tweak is written, if it fails to find an audience that feels that the tweak satisfies a need, then it becomes slowly lost into the depths of an oversaturated marketplace. This is, unfortunately, a microcosm in itself, as the same applies in basic economics for the real world. I wish to write a simple enough of a tweak to the best of my capabilities, but if I feel that the work itself is overdone by others, then I have little incentive to work on something that would be a waste of my time and energy. I can perfectly accept the possibility of my work being lost, because as mentioned before, the real world operates in just the same way, and this community is no different. But for something that I do in my free time as just a personal venture, if I don't feel that the project is meaningful to myself, then I prefer to spend my time elsewhere. 

I did eventually come up with a tweak idea that was simple enough that I was surprised didn't exist except for many outdated versions. Given that you're on this page right now, I'm sure you figured out by now what my idea was. However, this is the only idea that I felt would satisfy me in both being relatively simple for a beginner like me, that others would want, and be meaningful to myself to improve upon my programming and logical thinking skills. Therefore, because of the unlikelihood of any of the three reasons above being satisfied again, I don't plan on continuing tweak development after this project.  

Sadly, it is also very unlikely I'll update this project to make it compatible with whatever new update Apple comes up with. This repository can forked if you wish to update it to that or modify it yourself, or if you're a beginner like I once was, as a reference to get you started (I did my best to comment each line of code that I understood the best I can to make it understandable). But this will be the only tweak I'll create. I'll still try to maintain it the best I can, but I never intended on being a tweak developer, it was more to embark on an interesting venture to create something in such a strange sandboxed environment that Apple created, and that is where my fascination to write my own tweak to have it run in just the same environment stemmed from. 

However, after the statement I just said, I feel that I need to apologize to every single person that helped me along the way, because without every single person that I'm about to list off, this tweak wouldn't exist. And if they're anything like me, they may find that their own time was valuable, and for them to hear that their time was spent for a purpose that was never planned to be continued for the future... well, I've always felt terrible asking them all for help.

#### Credits

- [**Azzou**](https://twitter.com/AzzouDuGhetto) for providing everything necessary to help me create the editable list preference panel to add as many images as needed, biggest thanks to him, as without him taking so much time out of his day to explain and answer my numerous questions about specifiers, this tweak literally wouldn't exist the way it is, especially when I accidentally performed a satanic ritual on his phone. He's been an amazing help when I needed it the most, beyond anything that I had expected, so I desperately need to express my biggest thanks again.

- [**MrGcGamer**](https://twitter.com/MrGcGamer), a genius in his own way, for taking time out of his day to deal with my nonsense with libraries and .plists. Furthermore, extremely big credits to his amazing library [LibGcUniversal](https://github.com/MrGcGamer/LibGcUniversalDocumentation) for working in a way that I was worried I would have to implement manually. Without him also taking time out of his own day to update his library to help make my tweak handle images in a proper way, I would have a "bug" that I don't think I would have the capability to fix myself. This tweak also wouldn't exist the way it is without so much help from him in other places.

- [**Taki**](https://twitter.com/74k1_) for being there for the entire WSL setup, basically the backbone of this operation, because I don't Linux anything in my life. He's pretty stupid and fat sometimes, but he's extremely intelligent, I love this kid for what he is, he's an amazing friend, so I thank him for being by my side.

- [**Litten**](https://twitter.com/schneelittchen) being the kindest person I've met, but also for inadvertently telling me that tweak development in Windows 10 is possible, therefore starting this whole adventure to creating this project. Even though I read over the basic syntax of obj-c, I find that being able to refer to her open sourced works that I personally use on a daily basis and receiving explanations and suggestions proved to be the best resource possible. Her support every step of the way was invaluble, so I wholeheartedly need to express my thanks there.

There is also a [discord server](https://discord.gg/WWbjTum) where I've received help for more technical things of setting up my environment properly and giving me a general idea of how tweaks work, so I'd like to credit these amazing people too. 
- [**Beckett**](https://github.com/BeckettOBrien) for helping me since the beginning to lead me in the right direction for properly setting up Theos and the required toolchains, thus removing the initial worries I had about creating a tweak on a Windows 10 computer.
- [**Galactic**](https://twitter.com/dev_galactic) for helping me with the fundamentals of Logos syntax and how preferences work.
- **YulkyTulky** for taking time out of his day to help me with color pickers.
- [**iCraze**](https://twitter.com/icrazeios) for answering my question about how %group and %init work.
- [**Lazy**](https://twitter.com/wackyyaf) for explaining why a part of my code was wrong, therefore helping to prevent me from developing bad habits. 
- [**Lacertosus**](https://twitter.com/LacertosusDeus) for his many open source projects on Github that made me understand how UIViews worked.

While these next people below didn't directly involve themselves with the physical aspects of the tweak, I still credit them here because they still decided to help me, and that is already more than enough, so I equally just as appreciate them as much as the people above.
- [**Luki120**](https://twitter.com/Lukii120) for also helping me with the basics of how preferences work. However, more importantly, he was the silent motivation for me that tweak development is possible for a complete beginner like me. He had the same resources and help available as me and was able to create his own amazing work, so he was a big reason for me not to give up. 
- [**Woodfairy**](https://twitter.com/woodfairyd) and [**Lightmann**](https://www.reddit.com/user/_lightmann/) for helping me troubleshoot for a dumb issue that I caused myself and ending up teaching me the basics of CLI. I can definitely see the importance behind being able to navigate through that quickly, so thank you for this new piece of knowledge.
- [**Arya_06**](https://twitter.com/arya_1106) for helping when I literally didn't know what I was looking at and explaining the obj-c syntax for me, therefore making things clearer overall for me. Thank you for saving me so much time by helping me here, I truly appreciate it. 
- [**WilsontheWolf**](https://github.com/WilsontheWolf) for randomly installing the first deb I ever made. Even though we both knew the tweak it didn't do anything, seeing other people use my work felt really good and gave me the courage to continue and improve on my idea.

And then this legend, because without his videos overall, I would have immediately abandoned my idea since the beginning.
- [**Zane Helton**](https://www.youtube.com/watch?v=uNXd4KLLjhk&list=PLFWEDfSyl7h_K8Ew4rwTzlUPgWU7nKYri) for his amazing tweak development tutorial series, even though it's slightly outdated, but it was enough encouragement for even for a dummy like me to give tweak development a try.

#### Conclusion

Am I a tweak developer? No, absolutely not, I don't believe I am based off of this one tweak idea. That title belongs to those that put forth the effort into helping others and have an genuine interest in what they are doing instead of as a means to make easy money. Instead, I am more pleased that I have gained the valuable insight in what tweak developers have to go through, especially given my history of literally thinking the exact opposite. 

This repository will exist mainly here as a memento for myself that I was able to accomplish something in the end that I once deemed to be impossible for me. While I may be done with tweak development likely forever, this two-month journey most certainly hasn't left me with learning nothing. I have expanded upon my own knowledge of programming, where I've touched up on my interests of optimization methods, file pointers, and how threading generally works, and this I feel is essential as a way for me to apply what I've learned into the career paths I plan to go into. None of this would have been possible without the circumstances of meeting such astounding people and what I have learned from each and every one of them is beyond invaluable and means the world to me and I'm incredibly grateful for them, they truly are the best.

I'll still be around to see what's new in the community, that's something I don't want to miss, but I do want to end this off with a statement that they've all heard me say so many times.

*Thank you so much.*

## Installation

If you really want to know how to compile this project into a .deb on your own machine, I suggest you look up tutorials on getting the environment set up properly. Once you have a clear understanding of how it works, then when you come back to this page, you should know what to do. A note that this project depends heavily on [LibGcUniversal](https://github.com/MrGcGamer/LibGcUniversalDocumentation), as previously mentioned.
