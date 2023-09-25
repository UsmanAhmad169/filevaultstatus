###############################################################################
## EZO
## Copyleft Usman Ahmad (EZO) 2023
## Web : http://www.ezo.io
##
## This code is open source and may be copied and modified as long as the source
## code is always made freely available.
## Please refer to the General Public Licence http://www.gnu.org/ or Licence.txt**
################################################################################

package Ocsinventory::Agent::Modules::FileVaultStatus;


sub new {
    my $name="filevaultstatus";   #Set the name of your module here
    

    my (undef,$context) = @_;
    my $self = {};

    #Create a special logger for the module
    $self->{logger} = new Ocsinventory::Logger ({
        config => $context->{config}
    });

    $self->{logger}->{header}="[$name]";

    $self->{context}=$context;

    $self->{structure}= {
        name => $name,
        start_handler => undef,
        prolog_writer => undef, 
        prolog_reader => undef, 
        inventory_handler => $name."_inventory_handler",
        end_handler => undef
    };
 
    bless $self;
}



######### Hook methods ############

sub filevaultstatus_inventory_handler {
    my $self = shift;
    my $logger = $self->{logger};
    my $common = $self->{context}->{common};

    $logger->debug("Yeah you are in filevaultstatus_inventory_handler :)");

    my $command_result = `fdesetup status`;
    my $encryption_status = $command_result =~ /FileVault is On/ ? "ENABLED" : "DISABLED";

    push @{$common->{xmltags}->{FILEVAULTSTATUS}},
    {
        ENCRYPTIONSTATUS  => [$encryption_status]
    };
}


1;
