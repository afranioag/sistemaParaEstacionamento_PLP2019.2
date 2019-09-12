#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <math.h>
// constants
#define TRUE 1
#define FALSE 0
#define MAX_TIME 3
#define TRUCK_MIN_TAX 25
#define CAR_MIN_TAX 10
#define BIKE_MIN_TAX 6
#define TRUCK_POST_TAX 0.75
#define CAR_POST_TAX 0.5
#define BIKE_POST_TAX 0.25
#define BIKE_RATIO 2
#define CAR_RATIO 4
#define TRUCK_RATIO 1

typedef struct _client_{
    int id;
    int fee;
    int park;
    int arrival_hour, arrival_min;
    int departure_hour, departure_min;
    char plate[20];
    char vehicle;
}Client;

typedef struct _spots_{
    int size;
    int free;
    struct _client_ **clients;
}Spots;

typedef struct _parking_slots{
    struct _spots_ *parks[3];
}Park;

Park *park = NULL;

void wait()
{
    char ch;
    __fpurge(stdin);
    scanf("%c", &ch);
}


int *get_sizes_ratios(int size)
{
    int *output;
    int K = (size / (CAR_RATIO + TRUCK_RATIO + BIKE_RATIO));
    output = (int*)malloc(sizeof(int)*3);
    output[0] = K * CAR_RATIO;
    output[1] = K * TRUCK_RATIO;
    output[2] = K * BIKE_RATIO;
    return output;
}

Client **fill_with_null(int size)
{
    Client **output = NULL;
    output = (Client**)malloc(sizeof(Client*)*size);
    for(int i=0;i<size;i++)
        output[i] = NULL;
    return output;
}

void create_empty_park(int size)
{
    int *type_sizes;
    park = (Park*)malloc(sizeof(Park));
    /*park->parks = (Spots**)malloc(sizeof(Spots*)*3);*/
    type_sizes = get_sizes_ratios(size);
    for(int i=0;i<3;i++){
        park->parks[i] = (Spots*)malloc(sizeof(Spots));
        park->parks[i]->clients = fill_with_null(type_sizes[i]);
        park->parks[i]->size = type_sizes[i];
        park->parks[i]->free = type_sizes[i];
    }
    /*park->size = size;*/
    /*park->free = size;*/
}

void destroy_park()
{
    int i;
    for(int i=0;i<3;i++){
        for(int j=0;j<park->parks[i]->size;j++){
            if(park->parks[i]->clients[j]!=NULL) free(park->parks[i]->clients[j]);
        }
        free(park->parks[i]);
    }
    free(park->parks);
    free(park);
}

int hash_function(int id, int park_id)
{
    float aux = (park->parks[park_id]->size) * (((float)id * 0.5));
    unsigned int hash = floor(aux);
    return hash % park->parks[park_id]->size;
}

int get_id(char plate[20], int park_id)
{
    int temp = atoi(plate);
    unsigned int id = hash_function(temp, park_id);
    int k = 1;
    while((park->parks[park_id]->clients[id] != NULL) && (strcmp(park->parks[park_id]->clients[id]->plate,plate) != 0)){
        id = (id + k*k) % park->parks[park_id]->size;
        k++;
    }
    if((park->parks[park_id]->clients[id] != NULL) && (strcmp(park->parks[park_id]->clients[id]->plate,plate) == 0)){
        return id;
    }
    else{
        return -1;
    }
}

int generate_id(char plate[20],int park_id)
{
    int temp = atoi(plate);
    unsigned int id = hash_function(temp, park_id);
    int k = 1;
    while(park->parks[park_id]->clients[id]!=NULL && strcmp(park->parks[park_id]->clients[id]->plate,plate) != 0){
        id = (id + k*k) % park->parks[park_id]->size;
        k++;
    }
    if(park->parks[park_id]->clients[id] == NULL)
        return id;
    else
        return -1;
}

int get_hour()
{
    struct tm *actual_time;
    time_t seconds;
    time(&seconds);
    actual_time = localtime(&seconds);
    return actual_time->tm_hour;
}

int get_minute()
{
    struct tm *actual_time;
    time_t seconds;
    time(&seconds);
    actual_time = localtime(&seconds);
    return actual_time->tm_min;
}

char get_vehicle()
{
    int vehicle;
    while(TRUE){
        system("clear");
        printf("\n1 - CAR\n");
        printf("2 - TRUCK\n");
        printf("3 - BIKE\n");
        printf(">>> ");
        scanf("%d", &vehicle);
        switch(vehicle){
            case 1:
                return 'C';
            case 2:
                return 'T';
            case 3:
                return 'B';
            default:
                printf("Invalid option!\n");
                break;
        }
    }
}

int get_park(char vehicle)
{
    switch(vehicle){
        case 'C':
            return 0;
        case 'T':
            return 1;
        case 'B':
            return 2;
        default:
            exit(-1);
    }
}

Client* fill_new_client(Client* client)
{
    int park;
    system("clear");
    printf("----VEHICLE INFORMATIONS----\n");
    client = (Client*)malloc(sizeof(Client));
    printf("Plate?: ");
    scanf("%s",client->plate);
    __fpurge(stdin);
    printf("\nVehicle?: ");
    client->vehicle = get_vehicle();
    client->park = get_park(client->vehicle);
    client->id = generate_id(client->plate,client->park);
    client->arrival_hour = get_hour();
    client->arrival_min = get_minute();
    client->fee = 0;
    return client;
}

char *register_new_client()
{
    Client *temp = NULL;
    char *buffer;
    buffer = (char*)malloc(sizeof(char)*1024);
    temp = fill_new_client(temp);
    if(park->parks[temp->park]->free > 0){
        if(temp->id != -1){
            park->parks[temp->park]->clients[temp->id] = temp;
            park->parks[temp->park]->free--;
            sprintf(buffer,"Vehicle allocated at spot %d\n",temp->id);
        }
        else{
            int spot = get_id(temp->plate, temp->park);
            sprintf(buffer,"Vehicle with plate %s already at spot %d in park %d\n",temp->plate, spot, temp->park);
            free(temp);
        }
        return buffer;

    }
    sprintf(buffer, "Sorry, no spots avaiable at park %d.\n",temp->park);
    free(temp);
    return buffer;
}

int get_extra_time(int time)
{
    int extra;
    extra = time - MAX_TIME;
    if(extra > 0) return extra;
    else return 0;
}

int compute_fee(int time, char vehicle)
{
    int extra_time = get_extra_time(time);
    switch(vehicle){
        case 'T':
            return TRUCK_MIN_TAX + (extra_time * TRUCK_POST_TAX);
        case 'C':
            return CAR_MIN_TAX + (extra_time * CAR_POST_TAX);
        case 'B':
            return BIKE_MIN_TAX + (extra_time * BIKE_POST_TAX);
        default:
            printf("Something went wrong!\n\n");
            exit(-1);
    }
}

char *get_ticket(Client* client)
{
    int time_spent;
    char *buffer;
    buffer = (char*)malloc(sizeof(char)*1024);
    client->departure_hour = get_hour();
    client->departure_min = get_minute();
    time_spent = (client->departure_hour) - (client->arrival_hour);
    client->fee = compute_fee(time_spent,client->vehicle);
    sprintf(buffer,"---DIGITAL TICKET---\nPARK      --> %d\nSPOT ID   --> %d\nPLATE     --> %s\nVEHICLE   --> %c\nARRIVAL   --> %dh:%dm\nDEPARTURE --> %dh:%dm\nFEE       --> %d\n ",client->park+1, client->id, client->plate, client->vehicle, client->arrival_hour, client->arrival_min, client->departure_hour, client->departure_min, client->fee);
    return buffer;
}

void do_payment(int id, int park_id)
{
    free(park->parks[park_id]->clients[id]);
    park->parks[park_id]->clients[id] = NULL;
    park->parks[park_id]->free++;
}

int get_park_id()
{
    int park;
    system("clear");
    printf("\n1 - CAR PARK\n");
    printf("2 - TRUCK PARK\n");
    printf("3 - BIKE PARK\n");
    printf(">>> ");
    scanf("%d", &park);
    return park-1;
}
void checkout()
{
    int temp_id, park_id;
    char ch;
    char opt;
    char temp_plate[20];
    Client* temp_client;
    printf("Plate: ");
    __fpurge(stdin);
    scanf("%s",temp_plate);
    park_id = get_park_id();
    temp_id = get_id(temp_plate, park_id);
    if(temp_id != -1 && (park_id >= 0 && park_id < 3)){
        temp_client = park->parks[park_id]->clients[temp_id];
        puts(get_ticket(temp_client));
        printf("PAY? (Y)es\t(N)o\n");
        __fpurge(stdin);
        scanf("%c", &opt);
        switch(opt){
            case 'y':
                do_payment(temp_id, park_id);
                printf("Payment done!\n");
                wait();
                break;
            case 'n':
                break;
            default:
                printf("Invalid option!\n");
                break;
        }
    }
    else{
        system("clear");
        printf("Plate not found\n");
        wait();
    }
}

void menu()
{
    char ch;
    int opt, leave;
    leave = FALSE;
    while(TRUE){
        system("clear");
        printf("----Welcome to our digital parking system!----\n\n");
        printf("Car spots avaiable   ---> %d\n",park->parks[0]->free);
        printf("Truck spots avaiable ---> %d\n",park->parks[1]->free);
        printf("Bike spots avaiable  ---> %d\n",park->parks[2]->free);
        printf("1 - Register\n");
        printf("2 - Check\n");
        printf(">>> ");
        scanf("%d", &opt);
        switch(opt){
            case 1:
                puts(register_new_client());
                wait();
                break;
            case 2:
                checkout();
                break;
            case 123321:
                leave = TRUE;
                printf("bye!\n");
                break;
            default:
                printf("Invalid option!\n");
                break;
        }
        if(leave) break;
    }
}

int main(int argc, char* argv[])
{
    if(argc != 2) exit(-1);
    create_empty_park(atoi(argv[1]));
    menu();
    destroy_park();
}
