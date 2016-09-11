trigger setDefaultAccountValues on Account (before insert, before update) {
    for (Account oAccount : trigger.new) {
        if(oAccount.Name.Contains('Insurance')) {
            oAccount.Industry = 'Insurance';
        }else{
            oAccount.Industry = 'Technology';
        }
    }
}