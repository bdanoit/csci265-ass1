{
    if (match($0, "cew_Ncase\\("))
        { sub("cew_Ncase\\(", "cew_Ncase(" NR ","); }
    if (match($0, "cew_Ecase\\("))
        { sub("cew_Ecase\\(", "cew_Ecase(" NR ","); }
    print $0;
}

