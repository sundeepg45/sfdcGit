trigger setDefaultAccountValues on Account (before insert, before update) {
    for (Account oAccount : trigger.new) {
        if(oAccount.Name == 'Test Trigger') {
            oAccount.Industry = 'Cloud Computing';
        }else{
            oAccount.Industry = 'Technology';
        }
    }
}