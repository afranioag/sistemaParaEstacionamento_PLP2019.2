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

typedef struct _client_{
    int id, arrival, departure;
    int fee;
    char plate[20];
    char vehicle;
}Client;

typedef struct _parking_slots{
    int size;
    int free;
    struct _client_ **clients;
}Park;

Park* park = NULL;

void create_empty_park(int size)
{
    park = (Park*)malloc(sizeof(Park));
    park->clients = (Client**)malloc(sizeof(Client*)*size);
    for(int i=0;i<size;i++){
        park->clients[i] = NULL;
    }
    park->size = size;
    park->free = size;
}

void destroy_park()
{
    int i;
    for(i=0;i<park->size;i++){
        if(park->clients[i]!=NULL) free(park->clients[i]);
    }
    free(park->clients);
    free(park);
}

int hash_function(int id)
{
    float aux = (park->size) * (((float)id * 0.5));
    unsigned int hash = floor(aux);
    return hash % park->size;
}

int get_id(char plate[20])
{
    int temp = atoi(plate);
    unsigned int id = hash_function(temp);
    int k = 1;
    while((park->clients[id] != NULL) && (strcmp(park->clients[id]->plate,plate) != 0)){
        id = (id + k*k) % park->size;
        k++;
    }
    if((park->clients[id] != NULL) && (strcmp(park->clients[id]->plate,plate) == 0)){
        return id;
    }
    else{
        return -1;
    }
}

int generate_id(char plate[20])
{
    int temp = atoi(plate);
    unsigned int id = hash_function(temp);
    int k = 1;
    while(park->clients[id]!=NULL && strcmp(park->clients[id]->plate,plate) != 0){
        id = (id + k*k) % park->size;
        k++;
    }
    if(park->clients[id] == NULL)
        return id;
    else
        return -1;
}

int get_time()
{
    struct tm *actual_time;
    time_t seconds;
    time(&seconds);
    actual_time = localtime(&seconds);
    return actual_time->tm_hour;
}

char get_vehicle()
{
    int vehicle;
    while(TRUE){
        printf("\n1 - CAR\n");
        printf("2 - TRUCK\n");
        printf("3 - BIKE\n");
        printf(">> ");
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

Client* fill_new_client(Client* client)
{
    client = (Client*)malloc(sizeof(Client));
    printf("\nPlate?: ");
    scanf("%s",client->plate);
    __fpurge(stdin);
    printf("\nVehicle?: ");
    client->vehicle = get_vehicle();
    client->id = generate_id(client->plate);
    client->arrival = get_time();
    client->departure = -1;
    client->fee = 0;
    if(client->id != -1){
        return client;
    }
    free(client);
    return NULL;
}

int register_new_client()
{
    Client *temp = NULL;
    if(park->free > 0){
        temp = fill_new_client(temp);
        if(temp != NULL){
            park->clients[temp->id] = temp;
            park->free--;
            printf("Vehicle registered at spot %d.\n", temp->id);
            return TRUE;
        }

    }
    printf("No spots available or vehicle already registered.\n");
    return FALSE;
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

void get_ticket(Client* client)
{
    int time_spent;
    client->departure = get_time();
    time_spent = (client->departure) - (client->arrival);
    client->fee = compute_fee(time_spent,client->vehicle);
    printf("SPOT ID   --> %d\n", client->id);
    printf("PLATE     --> %s\n", client->plate);
    printf("VEHICLE   --> %c\n", client->vehicle);
    printf("ARRIVAL   --> %d\n", client->arrival);
    printf("DEPARTURE --> %d\n", client->departure);
    printf("FEE       --> %d\n", client->fee);

}

void do_payment(int id)
{
    free(park->clients[id]);
    park->clients[id] = NULL;
    park->free++;
}

void checkout()
{
    int temp_id;
    char opt;
    char temp_plate[20];
    Client* temp_client;
    printf("Plate?: ");
    scanf("%s",temp_plate);
    temp_id = get_id(temp_plate);
    if(temp_id != -1){
        temp_client = park->clients[temp_id];
        get_ticket(temp_client);
        printf("PAY? (Y)es\t(N)o\n");
        __fpurge(stdin);
        scanf("%c", &opt);
        switch(opt){
            case 'Y':
                do_payment(temp_id);
                break;
            case 'N':
                system("clear");
                break;
            default:
                printf("Invalid option!\n");
                break;
        }
    }
    else{
        printf("Plate not found\n");
    }
}
// incompleta
void menu()
{
    int opt;
    printf("1 - Register\n");
    printf("2 - Check\n");
    printf("3 - Search\n");
    printf(">>> ");
    scanf("%d", &opt);
    switch(opt){
        case 1:
            break;
        case 2:
            break;
        case 3:
            break;
        default:
            break;
    }
}

int main(int argc, char* argv[])
{
    int i;
    create_empty_park(1000);
    for(i=0;i<3;i++){
        register_new_client();
    }
    checkout();
    destroy_park();
}
