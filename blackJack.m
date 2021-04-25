% Patch Alpha 1.1.1
%   Deals a single deck (52 cards), without replacement to the deck until the
%   deck is finished
%   Tells the player what values in hand has hit/stand capabilities. 
%   Dealer hits on hard 17. Dealer can go bust but only if player doesn't
%   BJ or bust
%   Has betting functionality to add to the pot. Pot dissappears if loses
% Needs
%   Ace only has 1 value, JQK show as 10
%   There is no off deck -- error if hands run out during final deal
%   No split 

% bot script load
% load('blackJackStrategy.m');

% define deck values and deck set


cardVals = [1 2 3 4 5 6 7 8 9 10 10 10 10];
deck = [cardVals cardVals cardVals cardVals];
playing = "Y";

myW = 0;
houseW = 0;
myCash = 100;

while (playing == "y" || playing == "Y") && length(deck) > 4
    
    disp(['You have ' num2str(myCash) ' chips.']);
    betVal = input('Place Your Bet: ');
    while betVal > myCash
        betVal = input('You dont have enough money. Place a smaller bet: ');
    end
    
    disp(['You bet ' num2str(betVal) ' chips.']);    
    myCash = myCash - betVal;
    disp(['You now have ' num2str(myCash) ' chips.']);

    myHand = [];
    houseHand = [];

    [myHand, deck] = deal(myHand,deck);
    [houseHand, deck] = deal(houseHand,deck);

    myVal = sum(myHand);
    houseVal = sum(houseHand);
    upCard = houseHand(1);
    houseShow = ['House has a ' num2str(upCard)];
    disp(houseShow);
    playerShow = ['You have a ' num2str(myHand(1)) ' and a ' num2str(myHand(2))];
    disp(playerShow);
    message = 0;

    playerHit = input('Hit? (Y/N). To double type D ', 's');
    playerHit = detectBot(playerHit,myHand,upCard);
    
    if playerHit == "D" || playerHit == "d"
        myCash = myCash - betVal;
        disp(['You double your ' num2str(betVal) ' chips bet.']);
        disp(['You now have ' num2str(myCash) ' chips.']);
        betVal = betVal .* 2;
        playerHit = "Y";
    end

    while playerHit == "y" || playerHit == "Y"
        [mySplash, deck] = hit(deck);
        myHand(end+1) = mySplash;
        message = ['You drew ' num2str(mySplash)];
        disp(message);
        myVal = sum(myHand);
        message = ['You have ' num2str(myVal)];
        disp(message);
        if myVal > 21
            message = 'You Busted!';
            disp(message);
            houseW = houseW + 1;
            break;
        end
        
        playerHit = input('Hit? (Y/N) ', 's');
        playerHit = detectBot(playerHit,myHand,upCard);
        
        if playerHit == "D" || playerHit == "d"
            disp('You can only double on the first deal');
            playerHit = input('Hit? (Y/N) ', 's');
        end
    end

    houseShow = ['House has a ' num2str(houseVal)];
    disp(houseShow);

    while houseVal < 17 && myVal <= 21
        [houseSplash, deck] = hit(deck);
        houseHand(end+1) = houseSplash;
        message = ['House drew ' num2str(houseSplash)];
        disp(message);
        houseVal = sum(houseHand);
        message = ['House has ' num2str(houseVal)];
        disp(message);
        message = 33;
        if houseVal > 21
            message = 'House Busted!';
            disp(message);
            myCash = myCash + (2 .* betVal);
            disp(['You win ' num2str(betVal) ' chips']);
            myW = myW + 1;
            break;
        end
    end

    if message ~= 33
        message = ['House has ' num2str(houseVal)];
        disp(message);
    end

    if 21 - houseVal < 21 - myVal && myVal <= 21 && houseVal <=21
        message = 'House wins';
        houseW = houseW + 1;
        disp(message);
    end

    if 21 - houseVal > 21 - myVal && myVal <= 21 && houseVal <=21
        message = ['You win ' num2str(betVal) ' chips'];
        myCash = myCash + (2 .* betVal);
        myW = myW + 1;
        disp(message);
    end
    
    if myVal == houseVal
        message = 'Push!';
        myCash = myCash + betVal;
        disp(message);
    end

    playing = input('Play again? (Y/N)', 's');

end

disp(['House wins: ' num2str(houseW)]);
disp(['Your wins: ' num2str(myW)]);
disp(['Your money: ' num2str(myCash)]);
disp("Game Over!");


% MECHANICAL ENGINEERING-RELATED functions n stuff
function [hand, deck] = deal(hand,deck)
    for i = [1 2]
        r = randi(length(deck),1);
        hand(i) = deck(r);
        deck(r) = [];
    end
end

function [card, deck] = hit(deck)
    p = randi(length(deck),1);
    card = deck(p);
    deck(p) = [];
end

function check = detectBot(check,myHand,upCard)
    if strcmpi(check, "load bot")
        whatDo = blackJackBot(myHand,upCard);
        disp(['You should ' whatDo]);
        check = input('Hit? (Y/N) ', 's');
    end
end


% function bet(betAm)
% 
% end

